/** MemPalace extension for Pi — AUTO-GENERATED from `mempalace-mcp` tools/list
 * (server 3.10.0). Do not hand-edit: re-run /tmp/gen_aliases.py against a
 * live server (`tools/list` → /tmp/mcp_tools.json) and replace this file.
 *
 * Registers the MCP server via Pi's native support, plus bare-name aliases
 * so skills written against `mempalace_*` tools work verbatim. The server
 * stays on `codemode` exposure (callable, not declared); the 7 everyday
 * tools are `direct`, the rest `deferred` (loaded via tool_search) so 45
 * declarations don't ride every prompt. Pi owns the server lifetime.
 *
 * Transport is HTTP-first: if the shared `mempalace serve` daemon answers
 * on MEMPALACE_MCP_URL (default http://127.0.0.1:8765/mcp, loopback, kept
 * alive by com.mempalace.serve), all sessions share one writer and no
 * session can squat the palace lock. Otherwise it falls back to a per-
 * session stdio server (MEMPALACE_MCP_COMMAND). Transport selection below
 * is hand-maintained; only the tool aliases above are generated.
 */
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type, type Static } from "typebox";
const SERVER_COMMAND = process.env.MEMPALACE_MCP_COMMAND || "/Users/kevin/.local/bin/mempalace-mcp";

const StatusParams = Type.Object({});

const ListWingsParams = Type.Object({});

const ListRoomsParams = Type.Object({
	wing: Type.Optional(Type.String({ description: "Wing to list rooms for (optional)" })),
});

const GetTaxonomyParams = Type.Object({});

const GetAaakSpecParams = Type.Object({});

const KgQueryParams = Type.Object({
	entity: Type.String({ description: "Entity to query (e.g. 'Max', 'MyProject', 'Alice')" }),
	as_of: Type.Optional(Type.String({ description: "Date/datetime filter \u2014 only facts valid at this time (YYYY-MM-DD or YYYY-MM-DDTHH:MM:SSZ, optional)" })),
	direction: Type.Optional(Type.String({ description: "outgoing (entity\u2192?), incoming (?\u2192entity), or both (default: both)" })),
});

const KgAddParams = Type.Object({
	subject: Type.String({ description: "The entity doing/being something" }),
	predicate: Type.String({ description: "The relationship type (e.g. 'loves', 'works_on', 'daughter_of')" }),
	object: Type.String({ description: "The entity being connected to" }),
	valid_from: Type.Optional(Type.String({ description: "When this became true (YYYY-MM-DD or YYYY-MM-DDTHH:MM:SSZ, optional)" })),
	valid_to: Type.Optional(Type.String({ description: "When this stopped being true (YYYY-MM-DD or YYYY-MM-DDTHH:MM:SSZ, optional). Use for backfilling already-ended historical facts." })),
	source_closet: Type.Optional(Type.String({ description: "Closet ID where this fact appears (optional)" })),
	source_file: Type.Optional(Type.String({ description: "Source file path the fact was extracted from (optional)" })),
	source_drawer_id: Type.Optional(Type.String({ description: "Drawer ID the fact was extracted from (optional, RFC 002 provenance)" })),
});

const KgInvalidateParams = Type.Object({
	subject: Type.String({ description: "Entity" }),
	predicate: Type.String({ description: "Relationship" }),
	object: Type.String({ description: "Connected entity" }),
	ended: Type.Optional(Type.String({ description: "When it stopped being true (YYYY-MM-DD or YYYY-MM-DDTHH:MM:SSZ, default: today)" })),
});

const KgSupersedeParams = Type.Object({
	subject: Type.String({ description: "The entity whose fact is changing" }),
	predicate: Type.String({ description: "The relationship type (e.g. 'uses_model', 'works_at')" }),
	old_object: Type.String({ description: "The value being replaced" }),
	new_object: Type.String({ description: "The new value" }),
	at: Type.Optional(Type.String({ description: "Boundary instant (YYYY-MM-DD or YYYY-MM-DDTHH:MM:SSZ, optional; defaults to now UTC)" })),
});

const KgTimelineParams = Type.Object({
	entity: Type.Optional(Type.String({ description: "Entity to get timeline for (optional \u2014 omit for full timeline)" })),
	limit: Type.Optional(Type.Integer({ description: "Max facts per page (default 100, max 100)" })),
	offset: Type.Optional(Type.Integer({ description: "Offset for pagination (default 0)" })),
});

const KgStatsParams = Type.Object({});

const TraverseParams = Type.Object({
	start_room: Type.String({ description: "Room to start from (e.g. 'chromadb-setup', 'riley-school')" }),
	max_hops: Type.Optional(Type.Integer({ description: "How many connections to follow (default: 2)" })),
});

const FindTunnelsParams = Type.Object({
	wing_a: Type.Optional(Type.String({ description: "First wing (optional)" })),
	wing_b: Type.Optional(Type.String({ description: "Second wing (optional)" })),
});

const GraphStatsParams = Type.Object({});

const MeshPeersParams = Type.Object({});

const CreateTunnelParams = Type.Object({
	source_wing: Type.String({ description: "Wing of the source" }),
	source_room: Type.String({ description: "Room in the source wing" }),
	target_wing: Type.String({ description: "Wing of the target" }),
	target_room: Type.String({ description: "Room in the target wing" }),
	label: Type.Optional(Type.String({ description: "Description of the connection" })),
	source_drawer_id: Type.Optional(Type.String({ description: "Optional specific drawer ID" })),
	target_drawer_id: Type.Optional(Type.String({ description: "Optional specific drawer ID" })),
});

const ListTunnelsParams = Type.Object({
	wing: Type.Optional(Type.String({ description: "Filter tunnels by wing (shows tunnels where wing is source or target)" })),
});

const DeleteTunnelParams = Type.Object({
	tunnel_id: Type.String({ description: "Tunnel ID to delete" }),
});

const ListHallwaysParams = Type.Object({
	wing: Type.Optional(Type.String({ description: "Filter hallways by wing" })),
});

const DeleteHallwayParams = Type.Object({
	hallway_id: Type.String({ description: "Hallway ID to delete" }),
});

const FollowTunnelsParams = Type.Object({
	wing: Type.String({ description: "Wing to start from" }),
	room: Type.String({ description: "Room to follow tunnels from" }),
});

const SearchParams = Type.Object({
	query: Type.String({ description: "Short search query ONLY \u2014 keywords or a question. Max 250 chars." }),
	limit: Type.Optional(Type.Integer({ description: "Max results (default 5)" })),
	wing: Type.Optional(Type.String({ description: "Filter by wing (optional)" })),
	room: Type.Optional(Type.String({ description: "Filter by room (optional)" })),
	source_file: Type.Optional(Type.String({ description: "Filter to one exact source_file (optional). Matches the full stored path exactly (leading/trailing whitespace trimmed); no glob or basename matching. Pass the value from a result's 'source_path' field; the displayed 'source_file' is only a basename." })),
	since: Type.Optional(Type.String({ description: "Only drawers filed on/after this ISO date or datetime (inclusive), e.g. '2026-04-01' or '2026-04-01T09:30:00'. Compares the drawer's created_at (filed_at) wall-clock; drawers without a filed_at are excluded while set." })),
	before: Type.Optional(Type.String({ description: "Only drawers filed strictly before this ISO date or datetime (exclusive). Same comparison rules as 'since'." })),
	max_distance: Type.Optional(Type.Number({ description: "Max cosine distance threshold (0=identical, 2=opposite). Results further than this are dropped. Lower = stricter. Default 1.5. Set to 0 to disable." })),
	candidate_strategy: Type.Optional(Type.Union([Type.Literal("vector"), Type.Literal("union")], { description: "Candidate source strategy. 'vector' preserves default semantic search; 'union' also merges backend BM25 lexical candidates before reranking." })),
	cli_compatible: Type.Optional(Type.Boolean({ description: "Preserve standalone CLI candidate selection, ranking, and output. Used by the CLI Hub forwarder." })),
	context: Type.Optional(Type.String({ description: "Background context for the search (optional). NOT used for embedding \u2014 only for future re-ranking." })),
});

const CheckDuplicateParams = Type.Object({
	content: Type.String({ description: "Content to check" }),
	threshold: Type.Optional(Type.Number({ description: "Similarity threshold 0-1 (default 0.9)" })),
});

const AddDrawerParams = Type.Object({
	wing: Type.String({ description: "Wing (project name)" }),
	room: Type.String({ description: "Room (aspect: backend, decisions, meetings...)" }),
	content: Type.String({ description: "Verbatim content to store \u2014 exact words, never summarized" }),
	source_file: Type.Optional(Type.String({ description: "Where this came from (optional)" })),
	added_by: Type.Optional(Type.String({ description: "Who is filing this (default: mcp)" })),
});

const CheckpointParams = Type.Object({
	items: Type.Array(Type.Object({
	wing: Type.String({ description: "Wing (project name)" }),
	room: Type.String({ description: "Room (short topic: decisions, backend...)" }),
	content: Type.String({ description: "Verbatim content to store" }),
}), { description: "Verbatim items to file. Each is {wing, room, content} \u2014 content is the exact words, never summarized." }),
	diary: Type.Optional(Type.Object({
	agent_name: Type.Optional(Type.String({ description: "Agent name (e.g. cursor-ide)" })),
	entry: Type.Optional(Type.String({ description: "Diary entry in AAAK format" })),
	topic: Type.Optional(Type.String({ description: "Topic tag (optional)" })),
	wing: Type.Optional(Type.String({ description: "Target wing (optional)" })),
})),
	dedup_threshold: Type.Optional(Type.Number({ description: "Similarity threshold 0-1 for the per-item dedup check (default 0.9)" })),
	added_by: Type.Optional(Type.String({ description: "Who is filing these drawers. An explicit value takes precedence; otherwise the diary agent_name, else 'checkpoint'." })),
});

const DeleteDrawerParams = Type.Object({
	drawer_id: Type.String({ description: "ID of the drawer to delete" }),
});

const MineParams = Type.Object({
	source: Type.String({ description: "Directory to mine, or one conversation file with mode='convos'." }),
	mode: Type.Optional(Type.Union([Type.Literal("projects"), Type.Literal("convos"), Type.Literal("extract")], { description: "Ingest mode: projects (code/docs, default), convos (chat transcripts), extract (office docs)." })),
	wing: Type.Optional(Type.String({ description: "Target wing (default: source directory name)." })),
	agent: Type.Optional(Type.String({ description: "Recorded on every drawer (default: mempalace)." })),
	limit: Type.Optional(Type.Integer({ description: "Max files to process (0 = all). Default: 0." })),
	dry_run: Type.Optional(Type.Boolean({ description: "Report what would be filed without writing. Default: false." })),
	extract: Type.Optional(Type.Union([Type.Literal("exchange"), Type.Literal("general")], { description: "Convos extraction strategy: exchange (default) or general. Ignored by other modes." })),
});

const DeleteBySourceParams = Type.Object({
	source_file: Type.String({ description: "Exact source_file metadata value to remove (e.g. the full path that was mined)" }),
	dry_run: Type.Optional(Type.Boolean({ description: "Preview the match count without deleting; default true. Pass false to actually delete." })),
});

const SyncParams = Type.Object({
	project_dir: Type.Optional(Type.String({ description: "Project root to scope the sync (optional; auto-detected from drawer metadata if omitted)" })),
	wing: Type.Optional(Type.String({ description: "Limit to one wing (optional)" })),
	apply: Type.Optional(Type.Boolean({ description: "Actually delete drawers; default is dry-run preview" })),
});

const GetDrawerParams = Type.Object({
	drawer_id: Type.String({ description: "ID of the drawer to fetch" }),
});

const ListDrawersParams = Type.Object({
	wing: Type.Optional(Type.String({ description: "Filter by wing (optional)" })),
	room: Type.Optional(Type.String({ description: "Filter by room (optional)" })),
	since: Type.Optional(Type.String({ description: "Only drawers filed on or after this ISO date/time, inclusive (e.g. '2026-04-01'). Optional." })),
	before: Type.Optional(Type.String({ description: "Only drawers filed before this ISO date/time, exclusive (e.g. '2026-05-01'). Optional." })),
	limit: Type.Optional(Type.Integer({ description: "Max results per page (default 20, max 100)" })),
	offset: Type.Optional(Type.Integer({ description: "Offset for pagination (default 0)" })),
});

const UpdateDrawerParams = Type.Object({
	drawer_id: Type.String({ description: "ID of the drawer to update" }),
	content: Type.Optional(Type.String({ description: "New content (optional \u2014 omit to keep existing)" })),
	wing: Type.Optional(Type.String({ description: "New wing (optional \u2014 omit to keep existing)" })),
	room: Type.Optional(Type.String({ description: "New room (optional \u2014 omit to keep existing)" })),
});

const DiaryWriteParams = Type.Object({
	agent_name: Type.Optional(Type.String({ description: "Your name \u2014 each agent gets their own diary wing" })),
	entry: Type.Optional(Type.String({ description: "Your diary entry in AAAK format \u2014 compressed, entity-coded, emotion-marked" })),
	topic: Type.Optional(Type.String({ description: "Topic tag (optional, default: general)" })),
	wing: Type.Optional(Type.String({ description: "Target wing for this diary entry (optional). If omitted, uses wing_{agent_name}. Use this to write diary entries to a project wing instead of an agent-specific wing." })),
	content: Type.Optional(Type.String({ description: "Alias for 'entry' \u2014 accepted because add_drawer uses 'content'. Provide either 'entry' or 'content'; 'entry' wins if both are given." })),
});

const DiaryReadParams = Type.Object({
	agent_name: Type.Optional(Type.String({ description: "Your name \u2014 each agent gets their own diary wing" })),
	last_n: Type.Optional(Type.Integer({ description: "Number of recent entries to read (default: 10)" })),
	wing: Type.Optional(Type.String({ description: "Wing to read diary entries from (optional). If omitted, reads from wing_{agent_name}." })),
});

const HookSettingsParams = Type.Object({
	silent_save: Type.Optional(Type.Boolean({ description: "True = silent direct save, False = blocking MCP calls" })),
	desktop_toast: Type.Optional(Type.Boolean({ description: "True = show desktop toast via notify-send" })),
});

const MemoriesFiledAwayParams = Type.Object({});

const ReconnectParams = Type.Object({});

const EventAppendParams = Type.Object({
	type: Type.String({ description: "Event type, e.g. 'task.request', 'task.reply', 'patch.ready'" }),
	stream: Type.String({ description: "Logical stream, e.g. 'project/mempalace' or 'shared_agent_brain'" }),
	room: Type.String({ description: "Sub-channel, e.g. 'delegation', 'patches', 'reviews', 'status'" }),
	topic: Type.Optional(Type.String({ description: "Topic to group related work/sub-team, e.g. 'auth-v2', 'ui-redesign' (optional)" })),
	from_agent: Type.String({ description: "Writer agent identity" }),
	to_agent: Type.Optional(Type.String({ description: "Target agent, or '*' for broadcast (optional)" })),
	correlation_id: Type.Optional(Type.String({ description: "Task/conversation id tying request and reply events (optional)" })),
	branch: Type.Optional(Type.String({ description: "Git branch, when relevant (optional)" })),
	base_commit: Type.Optional(Type.String({ description: "Git commit the work started from (optional)" })),
	status: Type.Optional(Type.String({ description: "One of: open, claimed, ready, applied, blocked, failed, superseded (optional)" })),
	body: Type.Optional(Type.String({ description: "Verbatim human-readable content (optional, max 256 KiB)" })),
	metadata: Type.Optional(Type.Record(Type.String(), Type.Any())),
	artifact_ids: Type.Optional(Type.Array(Type.String(), { description: "Ids of already-stored artifacts to reference (optional)" })),
});

const TaskCreateParams = Type.Object({
	project: Type.String({ description: "Project routing name" }),
	from_agent: Type.String({ description: "Requesting agent identity" }),
	to_agent: Type.String({ description: "Worker agent identity" }),
	goal: Type.String({ description: "Exact verbatim task goal" }),
	branch: Type.String({ description: "Git branch for the work" }),
	base_commit: Type.String({ description: "Immutable hexadecimal commit id the worker must start from; branches and tags are rejected" }),
	done: Type.String({ description: "Exact verbatim definition of done" }),
});

const EventListParams = Type.Object({
	stream: Type.Optional(Type.String({ description: "Filter by stream (optional)" })),
	room: Type.Optional(Type.String({ description: "Filter by room (optional)" })),
	topic: Type.Optional(Type.String({ description: "Filter by topic (optional)" })),
	type: Type.Optional(Type.String({ description: "Filter by event type (optional)" })),
	to_agent: Type.Optional(Type.String({ description: "Filter by target agent; also matches '*' broadcasts (optional)" })),
	from_agent: Type.Optional(Type.String({ description: "Filter by writer (optional)" })),
	correlation_id: Type.Optional(Type.String({ description: "Filter by correlation id (optional)" })),
	status: Type.Optional(Type.String({ description: "Filter by status (optional)" })),
	since_event_id: Type.Optional(Type.String({ description: "Return only events strictly after this event id in append order (optional)" })),
	before_event_id: Type.Optional(Type.String({ description: "Return only events strictly before this event id in append order (optional)" })),
	since_created_at: Type.Optional(Type.String({ description: "Time window filter, inclusive: events created at or after this time (YYYY-MM-DD or YYYY-MM-DDTHH:MM:SSZ, optional). NOT a resume cursor \u2014 use since_event_id for that; a timestamp cursor silently drops peer events that sync in late. Dedup by id when using this." })),
	limit: Type.Optional(Type.Integer({ description: "Max events to return (default 50)" })),
	order: Type.Optional(Type.String({ description: "'desc' (newest first, default without cursor) or 'asc' (chronological forward, default with since_event_id, optional)" })),
	preview: Type.Optional(Type.Boolean({ description: "Truncate each event body to a short excerpt (marks body_truncated + body_length) so scanning many events stays cheap. since_event_id is strictly AFTER that id, so do not pass the truncated event's own id to re-fetch it \u2014 repeat the original filters with preview=false (default false)" })),
});

const EventWaitParams = Type.Object({
	stream: Type.Optional(Type.String({ description: "Filter by stream (optional)" })),
	room: Type.Optional(Type.String({ description: "Filter by room (optional)" })),
	topic: Type.Optional(Type.String({ description: "Filter by topic (optional)" })),
	type: Type.Optional(Type.String({ description: "Filter by event type (optional)" })),
	to_agent: Type.Optional(Type.String({ description: "Filter by target agent; also matches '*' broadcasts (optional)" })),
	from_agent: Type.Optional(Type.String({ description: "Filter by writer (optional)" })),
	correlation_id: Type.Optional(Type.String({ description: "Filter by correlation id (optional)" })),
	status: Type.Optional(Type.String({ description: "Filter by status (optional)" })),
	since_event_id: Type.Optional(Type.String({ description: "Only match events strictly after this event id (optional)" })),
	since_created_at: Type.Optional(Type.String({ description: "Time window filter, inclusive (optional). NOT a resume cursor \u2014 use since_event_id, which cannot skip a late-syncing peer event." })),
	timeout_ms: Type.Optional(Type.Integer({ description: "How long to wait in milliseconds (default 60000, max 300000)" })),
	limit: Type.Optional(Type.Integer({ description: "Max events to return when matches exist (default 50)" })),
});

const EventAckParams = Type.Object({
	event_id: Type.String({ description: "Id of the event to acknowledge" }),
	from_agent: Type.String({ description: "Acknowledging agent identity" }),
	status: Type.Optional(Type.String({ description: "One of: open, claimed, ready, applied, blocked, failed, superseded (optional)" })),
	body: Type.Optional(Type.String({ description: "Verbatim ack notes (optional)" })),
	topic: Type.Optional(Type.String({ description: "Topic override (defaults to target event's topic, optional)" })),
});

const ArtifactPutParams = Type.Object({
	kind: Type.String({ description: "One of: patch, file, log, json, note" }),
	content: Type.String({ description: "Exact artifact content" }),
	created_by: Type.String({ description: "Writer agent identity" }),
	metadata: Type.Optional(Type.Record(Type.String(), Type.Any())),
});

const ArtifactGetParams = Type.Object({
	artifact_id: Type.String({ description: "Artifact id to fetch" }),
});

const PatchSubmitParams = Type.Object({
	content: Type.String({ description: "Unified diff content" }),
	from_agent: Type.String({ description: "Submitting agent identity" }),
	stream: Type.String({ description: "Logical stream, e.g. 'project/mempalace'" }),
	room: Type.Optional(Type.String({ description: "Sub-channel (default 'patches')" })),
	topic: Type.Optional(Type.String({ description: "Topic name (optional)" })),
	to_agent: Type.Optional(Type.String({ description: "Target agent or '*' (optional)" })),
	correlation_id: Type.Optional(Type.String({ description: "Task id tying this patch to its request (optional)" })),
	branch: Type.Optional(Type.String({ description: "Git branch (optional)" })),
	base_commit: Type.Optional(Type.String({ description: "Git commit the patch applies to (optional)" })),
	body: Type.Optional(Type.String({ description: "Verbatim notes (optional)" })),
	metadata: Type.Optional(Type.Record(Type.String(), Type.Any())),
});

const MCP_URL = process.env.MEMPALACE_MCP_URL || "http://127.0.0.1:8765/mcp";

async function sharedDaemonUp(): Promise<boolean> {
	try {
		const ctrl = new AbortController();
		const timer = setTimeout(() => ctrl.abort(), 500);
		const res = await fetch(MCP_URL.replace(/\/mcp\/?$/, "/healthz"), { signal: ctrl.signal });
		clearTimeout(timer);
		return res.ok;
	} catch {
		return false;
	}
}

export default async function mempalaceExtension(pi: ExtensionAPI) {
	if (await sharedDaemonUp()) {
		pi.registerMcpServer("mempalace", {
			url: MCP_URL,
			exposure: "codemode",
			description: "MemPalace memory palace: semantic recall, diary, and knowledge graph.",
			timeout: 120,
		});
	} else {
		pi.registerMcpServer("mempalace", {
			command: SERVER_COMMAND,
			exposure: "codemode",
			description: "MemPalace memory palace: semantic recall, diary, and knowledge graph.",
			timeout: 120,
		});
	}

	async function alias(toolName: string, args: unknown, ctx: any, signal?: AbortSignal) {
		const outcome = await ctx.executeTool(`mcp__mempalace__${toolName}`, args, { signal });
		if (outcome.isError && !outcome.result.isError) {
			return { ...outcome.result, isError: true };
		}
		return outcome.result;
	};

	pi.registerTool({
		name: "mempalace_status",
		label: "mempalace status",
		description: "Palace overview \u2014 total drawers, wing and room counts",
		parameters: StatusParams,
		async execute(_toolCallId, params: Static<typeof StatusParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_status", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_list_wings",
		label: "mempalace list wings",
		description: "List all wings with drawer counts",
		exposure: "deferred",
		parameters: ListWingsParams,
		async execute(_toolCallId, params: Static<typeof ListWingsParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_list_wings", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_list_rooms",
		label: "mempalace list rooms",
		description: "List rooms within a wing (or all rooms if no wing given)",
		exposure: "deferred",
		parameters: ListRoomsParams,
		async execute(_toolCallId, params: Static<typeof ListRoomsParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_list_rooms", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_get_taxonomy",
		label: "mempalace get taxonomy",
		description: "Full taxonomy: wing \u2192 room \u2192 drawer count",
		exposure: "deferred",
		parameters: GetTaxonomyParams,
		async execute(_toolCallId, params: Static<typeof GetTaxonomyParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_get_taxonomy", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_get_aaak_spec",
		label: "mempalace get aaak spec",
		description: "Get the AAAK dialect specification \u2014 the compressed memory format MemPalace uses. Call this if you need to read or write AAAK-compressed memories.",
		exposure: "deferred",
		parameters: GetAaakSpecParams,
		async execute(_toolCallId, params: Static<typeof GetAaakSpecParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_get_aaak_spec", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_kg_query",
		label: "mempalace kg query",
		description: "Query the knowledge graph for an entity's relationships. Returns typed facts with temporal validity. E.g. 'Max' \u2192 child_of Alice, loves chess, does swimming. Filter by date with as_of to see what was true at a point in time.",
		parameters: KgQueryParams,
		async execute(_toolCallId, params: Static<typeof KgQueryParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_kg_query", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_kg_add",
		label: "mempalace kg add",
		description: "Add a fact to the knowledge graph. Subject \u2192 predicate \u2192 object with optional time window. E.g. ('Max', 'started_school', 'Year 7', valid_from='2026-09-01'). Pass valid_to to backfill an already-ended historical fact in a single call.",
		exposure: "deferred",
		parameters: KgAddParams,
		async execute(_toolCallId, params: Static<typeof KgAddParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_kg_add", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_kg_invalidate",
		label: "mempalace kg invalidate",
		description: "Mark a fact as no longer true. E.g. ankle injury resolved, job ended, moved house.",
		exposure: "deferred",
		parameters: KgInvalidateParams,
		async execute(_toolCallId, params: Static<typeof KgInvalidateParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_kg_invalidate", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_kg_supersede",
		label: "mempalace kg supersede",
		description: "Atomically replace a fact with its successor at a shared boundary. Use when a single-valued fact changes (model, employer, address) instead of separate kg_invalidate + kg_add \u2014 a point-in-time query at the boundary then returns only the new value.",
		exposure: "deferred",
		parameters: KgSupersedeParams,
		async execute(_toolCallId, params: Static<typeof KgSupersedeParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_kg_supersede", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_kg_timeline",
		label: "mempalace kg timeline",
		description: "Chronological timeline of facts with pagination. Shows the story of an entity (or everything) in order. Returns total matching count for pagination.",
		parameters: KgTimelineParams,
		async execute(_toolCallId, params: Static<typeof KgTimelineParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_kg_timeline", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_kg_stats",
		label: "mempalace kg stats",
		description: "Knowledge graph overview: entities, triples, current vs expired facts, relationship types.",
		exposure: "deferred",
		parameters: KgStatsParams,
		async execute(_toolCallId, params: Static<typeof KgStatsParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_kg_stats", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_traverse",
		label: "mempalace traverse",
		description: "Walk the palace graph from a room. Shows connected ideas across wings \u2014 the tunnels. Like following a thread through the palace: start at 'chromadb-setup' in wing_code, discover it connects to wing_myproject (planning) and wing_user (feelings about it).",
		exposure: "deferred",
		parameters: TraverseParams,
		async execute(_toolCallId, params: Static<typeof TraverseParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_traverse", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_find_tunnels",
		label: "mempalace find tunnels",
		description: "Find rooms that bridge two wings \u2014 the hallways connecting different domains. E.g. what topics connect wing_code to wing_team?",
		exposure: "deferred",
		parameters: FindTunnelsParams,
		async execute(_toolCallId, params: Static<typeof FindTunnelsParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_find_tunnels", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_graph_stats",
		label: "mempalace graph stats",
		description: "Palace graph overview: total rooms, tunnel connections, edges between wings.",
		exposure: "deferred",
		parameters: GraphStatsParams,
		async execute(_toolCallId, params: Static<typeof GraphStatsParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_graph_stats", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_mesh_peers",
		label: "mempalace mesh peers",
		description: "Mesh estate snapshot (RFC 004): this replica's identity, version vector and node profile; each configured peer's reachability, last sync outcome, remote version vector and advertised profile; origins known only transitively; origin_profiles keyed by replica_id; and estate_source saying whether the peer status was observed in this process or published by the palace's hub (with published_at and whether that hub is still alive). Exactly the GET /sync/peers payload \u2014 tokens are never included.",
		exposure: "deferred",
		parameters: MeshPeersParams,
		async execute(_toolCallId, params: Static<typeof MeshPeersParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_mesh_peers", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_create_tunnel",
		label: "mempalace create tunnel",
		description: "Create a cross-wing tunnel linking two palace locations. Use when content in one project relates to another \u2014 e.g., an API design in project_api connects to a database schema in project_database.",
		exposure: "deferred",
		parameters: CreateTunnelParams,
		async execute(_toolCallId, params: Static<typeof CreateTunnelParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_create_tunnel", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_list_tunnels",
		label: "mempalace list tunnels",
		description: "List all explicit cross-wing tunnels. Optionally filter by wing.",
		exposure: "deferred",
		parameters: ListTunnelsParams,
		async execute(_toolCallId, params: Static<typeof ListTunnelsParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_list_tunnels", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_delete_tunnel",
		label: "mempalace delete tunnel",
		description: "Delete an explicit tunnel by its ID.",
		exposure: "deferred",
		parameters: DeleteTunnelParams,
		async execute(_toolCallId, params: Static<typeof DeleteTunnelParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_delete_tunnel", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_list_hallways",
		label: "mempalace list hallways",
		description: "List within-wing hallway records (entity-to-entity co-occurrence links built at mine time). Optionally filter by wing.",
		exposure: "deferred",
		parameters: ListHallwaysParams,
		async execute(_toolCallId, params: Static<typeof ListHallwaysParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_list_hallways", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_delete_hallway",
		label: "mempalace delete hallway",
		description: "Delete a hallway record by its ID. Returns {deleted: bool}.",
		exposure: "deferred",
		parameters: DeleteHallwayParams,
		async execute(_toolCallId, params: Static<typeof DeleteHallwayParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_delete_hallway", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_follow_tunnels",
		label: "mempalace follow tunnels",
		description: "Follow tunnels from a room to see what it connects to in other wings. Returns connected rooms with drawer previews.",
		exposure: "deferred",
		parameters: FollowTunnelsParams,
		async execute(_toolCallId, params: Static<typeof FollowTunnelsParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_follow_tunnels", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_search",
		label: "mempalace search",
		description: "Semantic search. Returns verbatim drawer content with similarity scores. IMPORTANT: 'query' must contain ONLY search keywords. Use 'context' for background. Results with cosine distance > max_distance are filtered out.",
		parameters: SearchParams,
		async execute(_toolCallId, params: Static<typeof SearchParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_search", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_check_duplicate",
		label: "mempalace check duplicate",
		description: "Check if content already exists in the palace before filing",
		exposure: "deferred",
		parameters: CheckDuplicateParams,
		async execute(_toolCallId, params: Static<typeof CheckDuplicateParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_check_duplicate", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_add_drawer",
		label: "mempalace add drawer",
		description: "File verbatim content into the palace. Checks for duplicates first.",
		parameters: AddDrawerParams,
		async execute(_toolCallId, params: Static<typeof AddDrawerParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_add_drawer", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_checkpoint",
		label: "mempalace checkpoint",
		description: "Save a whole session in one call: semantic-dedups each item, files non-duplicates as drawers, then writes one diary entry. Use this instead of many separate check_duplicate/add_drawer/diary_write calls \u2014 it renders as a single tool-call card in the host UI.",
		exposure: "deferred",
		parameters: CheckpointParams,
		async execute(_toolCallId, params: Static<typeof CheckpointParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_checkpoint", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_delete_drawer",
		label: "mempalace delete drawer",
		description: "Delete a drawer by ID. Irreversible.",
		exposure: "deferred",
		parameters: DeleteDrawerParams,
		async execute(_toolCallId, params: Static<typeof DeleteDrawerParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_delete_drawer", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_mine",
		label: "mempalace mine",
		description: "Mine a directory into the palace \u2014 the MCP equivalent of `mempalace mine`. mode='convos' also accepts a single conversation file. mode='projects' (default) ingests code/docs; mode='convos' ingests chat transcripts; mode='extract' ingests office documents (PDF/DOCX/RTF, requires the mempalace[extract] extra). Runs synchronously and returns the miner's summary as `output`. The palace write lock is automatic; a concurrent mine returns a structured already-running error. Orphan cleanup is separate \u2014 use mempalace_sync.",
		exposure: "deferred",
		parameters: MineParams,
		async execute(_toolCallId, params: Static<typeof MineParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_mine", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_delete_by_source",
		label: "mempalace delete by source",
		description: "Bulk-delete every drawer mined from one source_file (exact match). Use to clean up benchmark/test data accidentally mined into a user wing (#1722). Returns a dry-run match count and sample by default; pass dry_run=false to commit. Irreversible.",
		exposure: "deferred",
		parameters: DeleteBySourceParams,
		async execute(_toolCallId, params: Static<typeof DeleteBySourceParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_delete_by_source", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_sync",
		label: "mempalace sync",
		description: "Prune drawers whose source files are gitignored, deleted, or moved. Returns dry-run report by default; pass apply=true to commit deletions.",
		exposure: "deferred",
		parameters: SyncParams,
		async execute(_toolCallId, params: Static<typeof SyncParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_sync", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_get_drawer",
		label: "mempalace get drawer",
		description: "Fetch a single drawer by ID \u2014 returns full content and metadata.",
		exposure: "deferred",
		parameters: GetDrawerParams,
		async execute(_toolCallId, params: Static<typeof GetDrawerParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_get_drawer", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_list_drawers",
		label: "mempalace list drawers",
		description: "List drawers with pagination. Optional wing/room filter and since/before date filter on filed_at (since inclusive, before exclusive; drawers without a parseable filed_at are excluded when a date bound is set). Returns IDs, wings, rooms, content previews, and total matching count for pagination.",
		exposure: "deferred",
		parameters: ListDrawersParams,
		async execute(_toolCallId, params: Static<typeof ListDrawersParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_list_drawers", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_update_drawer",
		label: "mempalace update drawer",
		description: "Update an existing drawer's content and/or metadata (wing, room). Fetches existing drawer first; returns error if not found.",
		exposure: "deferred",
		parameters: UpdateDrawerParams,
		async execute(_toolCallId, params: Static<typeof UpdateDrawerParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_update_drawer", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_diary_write",
		label: "mempalace diary write",
		description: "Write to your personal agent diary in AAAK format. Your observations, thoughts, what you worked on, what matters. Each agent has their own diary with full history. Write in AAAK for compression \u2014 e.g. 'SESSION:2026-04-04|built.palace.graph+diary.tools|ALC.req:agent.diaries.in.aaak|\u2605\u2605\u2605'. Use entity codes from the AAAK spec.",
		parameters: DiaryWriteParams,
		async execute(_toolCallId, params: Static<typeof DiaryWriteParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_diary_write", { agent_name: "pi", ...params }, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_diary_read",
		label: "mempalace diary read",
		description: "Read your recent diary entries (in AAAK). See what past versions of yourself recorded \u2014 your journal across sessions.",
		parameters: DiaryReadParams,
		async execute(_toolCallId, params: Static<typeof DiaryReadParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_diary_read", { agent_name: "pi", ...params }, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_hook_settings",
		label: "mempalace hook settings",
		description: "Get or set hook behavior. silent_save: True = save directly (no MCP clutter), False = legacy blocking. desktop_toast: True = show desktop notification. Call with no args to view.",
		exposure: "deferred",
		parameters: HookSettingsParams,
		async execute(_toolCallId, params: Static<typeof HookSettingsParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_hook_settings", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_memories_filed_away",
		label: "mempalace memories filed away",
		description: "Check if a recent palace checkpoint was saved. Returns message count and timestamp.",
		exposure: "deferred",
		parameters: MemoriesFiledAwayParams,
		async execute(_toolCallId, params: Static<typeof MemoriesFiledAwayParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_memories_filed_away", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_reconnect",
		label: "mempalace reconnect",
		description: "Force reconnect to the palace database. Use after external scripts or CLI commands modified the palace directly, which can leave the in-memory HNSW index stale.",
		exposure: "deferred",
		parameters: ReconnectParams,
		async execute(_toolCallId, params: Static<typeof ReconnectParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_reconnect", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_event_append",
		label: "mempalace event append",
		description: "Append an immutable agent-coordination event to the logstream (RFC 003). Use for delegating work (task.request), replying (task.reply), and announcing artifacts (patch.ready). Events are append-only; corrections are new events.",
		exposure: "deferred",
		parameters: EventAppendParams,
		async execute(_toolCallId, params: Static<typeof EventAppendParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_event_append", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_task_create",
		label: "mempalace task create",
		description: "Create a complete immutable task.request for another agent and return its exact stored event plus one short ready-to-paste handoff line. Use this instead of assembling raw task fields, especially when connected to a remote shared-brain hub. The caller must preview the exact task with the user before this append.",
		exposure: "deferred",
		parameters: TaskCreateParams,
		async execute(_toolCallId, params: Static<typeof TaskCreateParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_task_create", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_event_list",
		label: "mempalace event list",
		description: "List agent-coordination events with structured filters. Defaults to order='desc' (newest events first) when since_event_id is omitted (e.g. for sweeping recent inbox or inspecting recent history); defaults to order='asc' (chronological forward order) when resuming from since_event_id. Explicit order always overrides this default. Use since_event_id as the resume cursor: it means strictly AFTER that event in append order (rowid > anchor), so it cannot skip anything. For reverse/historical paging, use before_event_id (rowid < anchor). Do NOT resume with since_created_at \u2014 a peer's event syncs in whenever it arrives, so it can already be older than a timestamp cursor and be missed permanently; since_created_at is a time window ('what happened today'), not a cursor. Pass preview=true when sweeping a busy stream. to_agent=<you> also matches '*' broadcasts. To wait for future events, use mempalace_event_wait.",
		exposure: "deferred",
		parameters: EventListParams,
		async execute(_toolCallId, params: Static<typeof EventListParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_event_list", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_event_wait",
		label: "mempalace event wait",
		description: "Block until a matching coordination event exists or the timeout expires (default 60s, max 5 minutes). Returns {timed_out: true, events: []} on timeout \u2014 a normal result, not an error. This is the right tool for actively waiting on a correlation_id you delegated or claimed. It already backs off internally, so do not wrap it in a tight retry loop: on timeout just call it again with since_event_id updated to the last event you processed. For long-lived consumers (daemons, dashboards) prefer the push stream at GET /logstream/stream, which takes the live-tail filter subset and the same since_event_id resume.",
		exposure: "deferred",
		parameters: EventWaitParams,
		async execute(_toolCallId, params: Static<typeof EventWaitParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_event_wait", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_event_ack",
		label: "mempalace event ack",
		description: "Acknowledge a coordination event: appends a new event.ack routed back to the original writer with the correlation id copied. Never mutates the target event.",
		exposure: "deferred",
		parameters: EventAckParams,
		async execute(_toolCallId, params: Static<typeof EventAckParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_event_ack", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_artifact_put",
		label: "mempalace artifact put",
		description: "Store exact artifact content (unified diff patch, file, log, json, note) for agent handoffs. Returns id, sha256, and size_bytes. UTF-8 text only, max 4 MiB.",
		exposure: "deferred",
		parameters: ArtifactPutParams,
		async execute(_toolCallId, params: Static<typeof ArtifactPutParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_artifact_put", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_artifact_get",
		label: "mempalace artifact get",
		description: "Fetch a coordination artifact by id \u2014 exact content plus sha256 for verification.",
		exposure: "deferred",
		parameters: ArtifactGetParams,
		async execute(_toolCallId, params: Static<typeof ArtifactGetParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_artifact_get", params, ctx, signal);
		},
	});

	pi.registerTool({
		name: "mempalace_patch_submit",
		label: "mempalace patch submit",
		description: "Convenience: store a patch artifact and append its patch.ready event in one call. Use when handing completed work to another agent.",
		exposure: "deferred",
		parameters: PatchSubmitParams,
		async execute(_toolCallId, params: Static<typeof PatchSubmitParams>, signal, _onUpdate, ctx) {
			return alias("mempalace_patch_submit", params, ctx, signal);
		},
	});
}
