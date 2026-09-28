/**
 * MemPalace Extension for Pi
 *
 * Proxies the MemPalace MCP server (mempalace-mcp over stdio) into Pi as
 * model-callable tools, so memory-palace recall and filing work in Pi
 * sessions exactly like in MCP-connected harnesses. Tool names mirror the
 * MCP names, so skills written against `mempalace_*` tools work verbatim.
 *
 * The server process starts lazily on the first tool call (never in the
 * factory — some invocations load extensions without starting a session)
 * and is reaped by an idempotent `session_shutdown` handler. Override the
 * server binary with MEMPALACE_MCP_COMMAND; the default palace resolves
 * from ~/.mempalace/config.json (never pass a --palace pointing elsewhere).
 */

import { spawn, type ChildProcess } from "node:child_process";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type, type Static } from "typebox";

const SERVER_COMMAND = process.env.MEMPALACE_MCP_COMMAND || "/Users/kevin/.local/bin/mempalace-mcp";
const CALL_TIMEOUT_MS = 120_000;
const MAX_TEXT_CHARS = 24_000;

interface PendingCall {
	resolve: (result: unknown) => void;
	reject: (err: Error) => void;
	timer: ReturnType<typeof setTimeout>;
}

/** Minimal JSON-RPC-over-stdio client for a single MCP server process. */
class MemPalaceClient {
	private proc: ChildProcess | null = null;
	private nextId = 1;
	private pending = new Map<number, PendingCall>();
	private buffer = "";
	private ready: Promise<void> | null = null;
	private queue: Promise<unknown> = Promise.resolve();
	private shutDown = false;

	/** Spawn the server and complete the MCP handshake (idempotent). */
	private ensureReady(): Promise<void> {
		if (this.ready) return this.ready;
		this.ready = new Promise<void>((resolve, reject) => {
			let child: ChildProcess;
			try {
				child = spawn(SERVER_COMMAND, [], { stdio: ["pipe", "pipe", "ignore"] });
			} catch (err) {
				reject(new Error(`Failed to spawn ${SERVER_COMMAND}: ${(err as Error).message}`));
				return;
			}
			child.on("error", (err) => {
				this.failAll(new Error(`mempalace-mcp process error: ${err.message}`));
				this.proc = null;
				this.ready = null;
				reject(err);
			});
			child.on("exit", () => {
				this.failAll(new Error("mempalace-mcp exited unexpectedly"));
				this.proc = null;
				this.ready = null;
			});
			child.stdout!.on("data", (chunk: Buffer) => this.onData(chunk));
			this.proc = child;
			this.rawCall("initialize", {
				protocolVersion: "2024-11-05",
				capabilities: {},
				clientInfo: { name: "pi-mempalace-extension", version: "0.1.0" },
			}).then(
				() => {
					this.notify("notifications/initialized");
					resolve();
				},
				(err) => {
					this.ready = null;
					reject(err);
				},
			);
		});
		return this.ready;
	}

	private onData(chunk: Buffer): void {
		this.buffer += chunk.toString("utf-8");
		let idx: number;
		while ((idx = this.buffer.indexOf("\n")) >= 0) {
			const line = this.buffer.slice(0, idx).trim();
			this.buffer = this.buffer.slice(idx + 1);
			if (!line) continue;
			let msg: any;
			try {
				msg = JSON.parse(line);
			} catch {
				continue; // server log line on stdout: not our message
			}
			if (msg.id !== undefined && this.pending.has(msg.id)) {
				const call = this.pending.get(msg.id)!;
				this.pending.delete(msg.id);
				clearTimeout(call.timer);
				if (msg.error) {
					call.reject(new Error(`mempalace error: ${msg.error.message ?? JSON.stringify(msg.error)}`));
				} else {
					call.resolve(msg.result);
				}
			}
		}
	}

	private send(obj: unknown): void {
		if (!this.proc?.stdin) throw new Error("mempalace-mcp is not running");
		this.proc.stdin.write(JSON.stringify(obj) + "\n");
	}

	private notify(method: string): void {
		this.send({ jsonrpc: "2.0", method });
	}

	private rawCall(method: string, params: unknown): Promise<unknown> {
		const id = this.nextId++;
		return new Promise<unknown>((resolve, reject) => {
			const timer = setTimeout(() => {
				this.pending.delete(id);
				reject(new Error(`mempalace call '${method}' timed out after ${CALL_TIMEOUT_MS}ms`));
			}, CALL_TIMEOUT_MS);
			this.pending.set(id, { resolve, reject, timer });
			try {
				this.send({ jsonrpc: "2.0", id, method, params });
			} catch (err) {
				this.pending.delete(id);
				clearTimeout(timer);
				reject(err);
			}
		});
	}

	private failAll(err: Error): void {
		for (const call of this.pending.values()) {
			clearTimeout(call.timer);
			call.reject(err);
		}
		this.pending.clear();
	}

	/** Call an MCP tool method. Serialized: one in-flight request at a time. */
	async callTool(name: string, args: Record<string, unknown>, signal?: AbortSignal): Promise<unknown> {
		await this.ensureReady();
		const run = this.queue.then(() =>
			this.rawCall("tools/call", { name, arguments: args }),
		);
		// Keep the chain alive for later calls even if this one fails.
		this.queue = run.then(
			() => undefined,
			() => undefined,
		);
		if (!signal) return run;
		return new Promise<unknown>((resolve, reject) => {
			if (signal.aborted) {
				reject(new Error(`mempalace call '${name}' aborted`));
				return;
			}
			const onAbort = () => reject(new Error(`mempalace call '${name}' aborted`));
			signal.addEventListener("abort", onAbort, { once: true });
			run.then(
				(result) => {
					signal.removeEventListener("abort", onAbort);
					resolve(result);
				},
				(err) => {
					signal.removeEventListener("abort", onAbort);
					reject(err);
				},
			);
		});
	}

	/** Idempotent: kill the server, drop queued waiters, allow respawn. */
	shutdown(): void {
		this.shutDown = true;
		this.failAll(new Error("mempalace-mcp shut down with the session"));
		try {
			this.proc?.kill();
		} catch {
			// Already gone: nothing to do.
		}
		this.proc = null;
		this.ready = null;
		this.shutDown = false;
	}
}

/** Extract readable text from an MCP tools/call result, truncated for context. */
function resultText(result: unknown): string {
	const content = (result as any)?.content;
	const parts = Array.isArray(content) ? content : [];
	const text = parts
		.filter((part: any) => part?.type === "text" && typeof part.text === "string")
		.map((part: any) => part.text)
		.join("\n");
	if (text.length > MAX_TEXT_CHARS) {
		return (
			text.slice(0, MAX_TEXT_CHARS) +
			`\n[truncated: ${text.length - MAX_TEXT_CHARS} more chars omitted for context]`
		);
	}
	return text || JSON.stringify(result).slice(0, MAX_TEXT_CHARS);
}

const SearchParams = Type.Object({
	query: Type.String({ description: "Short search query ONLY — keywords or a question. Max 250 chars." }),
	limit: Type.Optional(Type.Integer({ description: "Max results (default 5)", minimum: 1, maximum: 100 })),
	wing: Type.Optional(Type.String({ description: "Filter by wing (project name)" })),
	room: Type.Optional(Type.String({ description: "Filter by room (aspect)" })),
	max_distance: Type.Optional(
		Type.Number({ description: "Max cosine distance threshold. Lower = stricter. Default 1.5." }),
	),
	context: Type.Optional(Type.String({ description: "Background context (not used for embedding)" })),
});

const AddDrawerParams = Type.Object({
	wing: Type.String({ description: "Wing (project name)" }),
	room: Type.String({ description: "Room (aspect: backend, decisions, meetings...)" }),
	content: Type.String({ description: "Verbatim content to store — exact words, never summarized" }),
	source_file: Type.Optional(Type.String({ description: "Where this came from" })),
	added_by: Type.Optional(Type.String({ description: "Who is filing this" })),
});

const StatusParams = Type.Object({});

const KgTimelineParams = Type.Object({
	entity: Type.Optional(Type.String({ description: "Entity for the timeline; omit for full timeline" })),
});

const KgQueryParams = Type.Object({
	entity: Type.String({ description: "Entity to query (e.g. 'Max', 'MyProject')" }),
	as_of: Type.Optional(
		Type.String({ description: "Only facts valid at this time (YYYY-MM-DD or full datetime)" }),
	),
	direction: Type.Optional(
		Type.String({ description: "outgoing, incoming, or both (default: both)" }),
	),
});

const DiaryReadParams = Type.Object({
	agent_name: Type.Optional(Type.String({ description: "Diary owner (default: pi)" })),
	last_n: Type.Optional(Type.Integer({ description: "Recent entries to read (default: 10)", minimum: 1 })),
	wing: Type.Optional(Type.String({ description: "Wing to read from (default: wing_<agent_name>)" })),
});

const DiaryWriteParams = Type.Object({
	agent_name: Type.Optional(Type.String({ description: "Diary owner (default: pi)" })),
	entry: Type.String({ description: "Diary entry in AAAK format — compressed, entity-coded" }),
	topic: Type.Optional(Type.String({ description: "Topic tag (default: general)" })),
	wing: Type.Optional(Type.String({ description: "Target wing (default: wing_<agent_name>)" })),
});

export default function mempalaceExtension(pi: ExtensionAPI) {
	const client = new MemPalaceClient();

	async function proxy(
		name: string,
		args: Record<string, unknown>,
		signal?: AbortSignal,
	): Promise<{ content: Array<{ type: "text"; text: string }>; details: undefined }> {
		const result = await client.callTool(name, args, signal);
		return { content: [{ type: "text", text: resultText(result) }], details: undefined };
	}

	pi.registerTool({
		name: "mempalace_search",
		label: "mempalace search",
		description:
			"Semantic search over the MemPalace memory palace. Returns verbatim drawer content with similarity scores. 'query' must contain ONLY search keywords; scope with wing/room.",
		parameters: SearchParams,
		async execute(_toolCallId, params: Static<typeof SearchParams>, signal) {
			return proxy("mempalace_search", params as Record<string, unknown>, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_add_drawer",
		label: "mempalace add drawer",
		description: "File a memory (drawer) in the MemPalace palace. Content is stored verbatim — pass exact words, never a summary.",
		parameters: AddDrawerParams,
		async execute(_toolCallId, params: Static<typeof AddDrawerParams>, signal) {
			return proxy("mempalace_add_drawer", params as Record<string, unknown>, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_status",
		label: "mempalace status",
		description: "Palace overview — total drawers, wing and room counts.",
		parameters: StatusParams,
		async execute(_toolCallId, _params: Static<typeof StatusParams>, signal) {
			return proxy("mempalace_status", {}, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_kg_timeline",
		label: "mempalace timeline",
		description: "Chronological timeline of knowledge-graph facts: the story of an entity (or everything) in order.",
		parameters: KgTimelineParams,
		async execute(_toolCallId, params: Static<typeof KgTimelineParams>, signal) {
			return proxy("mempalace_kg_timeline", params as Record<string, unknown>, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_kg_query",
		label: "mempalace graph query",
		description: "Query the palace knowledge graph for an entity's relationships. Returns typed facts with temporal validity.",
		parameters: KgQueryParams,
		async execute(_toolCallId, params: Static<typeof KgQueryParams>, signal) {
			return proxy("mempalace_kg_query", params as Record<string, unknown>, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_diary_read",
		label: "mempalace diary read",
		description: "Read recent diary entries (AAAK format) — what past sessions recorded. Defaults to the 'pi' diary.",
		parameters: DiaryReadParams,
		async execute(_toolCallId, params: Static<typeof DiaryReadParams>, signal) {
			return proxy(
				"mempalace_diary_read",
				{ agent_name: "pi", ...params } as Record<string, unknown>,
				signal,
			);
		},
	});

	pi.registerTool({
		name: "mempalace_diary_write",
		label: "mempalace diary write",
		description: "Write a diary entry in AAAK format (compressed, entity-coded). Defaults to the 'pi' diary.",
		parameters: DiaryWriteParams,
		async execute(_toolCallId, params: Static<typeof DiaryWriteParams>, signal) {
			return proxy(
				"mempalace_diary_write",
				{ agent_name: "pi", ...params } as Record<string, unknown>,
				signal,
			);
		},
	});

	pi.on("session_shutdown", async () => {
		client.shutdown();
	});
}
