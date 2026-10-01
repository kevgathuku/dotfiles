/**
 * MemPal autosave extension for Pi.
 *
 * Mirrors mempalace-autosave's lifecycle mapping (turn_end periodic + final
 * session_shutdown), but mempal has no conversation-mining tool — it ingests
 * directories. So this extension does two lighter things instead:
 *
 *   1. On session_start: `mempal init` the cwd if the wing has no drawers yet
 *      (idempotent: skips if `mempal status` already shows the wing).
 *   2. On session_shutdown: `mempal ingest <cwd>` so any files the agent
 *      edited/wrote during the session get filed. Content-hash dedupe makes
 *      this safe to run every shutdown.
 *
 * Periodic turn_end just touches `mempal status` to refresh L0/L1 if you
 * have MEMPAL_AUTOSAVE_TURNS>0 — cheap (no I/O), keeps the wake-up cache
 * warm. Set MEMPAL_AUTOSAVE_TURNS=0 to disable the periodic pass.
 *
 * Configuration (environment):
 * - MEMPAL_AUTOSAVE_TURNS (default "0"): periodic refresh every N turns.
 * - MEMPAL_AUTOSAVE_ON_SHUTDOWN (default "1"): "0" disables the ingest.
 * - MEMPAL_AUTOSAVE_WING: wing name override. Default derives from cwd
 *   basename with non-alphanumerics -> "_", matching mempal's convention.
 * - MEMPAL_BIN: mempal binary (default `$HOME/.cargo/bin/mempal`).
 *
 * Failures are silent by design: memory must never interrupt the session.
 */

import { execFile } from "node:child_process";
import * as os from "node:os";
import * as path from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const TURNS_BETWEEN_TOUCHES =
	Number.parseInt(process.env.MEMPAL_AUTOSAVE_TURNS ?? "0", 10);
const INGEST_ON_SHUTDOWN = (process.env.MEMPAL_AUTOSAVE_ON_SHUTDOWN ?? "1") !== "0";
const MEMPAL = process.env.MEMPAL_BIN || path.join(os.homedir(), ".cargo", "bin", "mempal");
const INGEST_TIMEOUT_MS = 300_000;
const TOUCH_TIMEOUT_MS = 30_000;
const PI_SESSIONS_ROOT = process.env.MEMPAL_AUTOSAVE_SESSIONS_DIR || path.join(os.homedir(), ".pi", "agent", "sessions");

function wingForDirectory(dir: string): string {
	const override = process.env.MEMPAL_AUTOSAVE_WING;
	if (override && override.trim().length > 0) return override.trim();
	const base = path.basename(path.resolve(dir));
	const wing = base.toLowerCase().replace(/[^a-z0-9]+/g, "_");
	return wing.length > 0 ? wing : "general";
}

// Map a working directory to its pi session-dir path. Pi encodes cwd as
// --Users-kevin-dotfiles-- etc.; we do the same encoding locally.
function sessionDirFor(cwd: string): string {
	const resolved = path.resolve(cwd);
	const slashed = resolved.replace(/^\//, "").replace(/\//g, "-");
	return path.join(PI_SESSIONS_ROOT, `--${slashed}--`);
}

function run(args: string[], timeoutMs: number): Promise<string> {
	return new Promise((resolve) => {
		execFile(MEMPAL, args, { timeout: timeoutMs }, (_err, stdout) =>
			resolve((stdout || "").toString()),
		);
	});
}

function wingKnown(wing: string): Promise<boolean> {
	return new Promise((resolve) => {
		execFile(
			MEMPAL,
			["projects"],
			{ timeout: TOUCH_TIMEOUT_MS },
			(_err, stdout) => {
				resolve(((stdout || "").toString()).includes(wing));
			},
		);
	});
}

export default function mempalAutosave(pi: ExtensionAPI) {
	let turnsSinceTouch = 0;
	let didInitThisSession = false;

	pi.on("session_start", async (_event, ctx) => {
		try {
			const dir = ctx.cwd;
			const wing = wingForDirectory(dir);
			if (await wingKnown(wing)) return;
			didInitThisSession = true;
			// Fire and forget: init can scan a large tree.
			void run(["init", dir, "--wing", wing], 120_000);
		} catch {
			/* silent */
		}
	});

	pi.on("turn_end", async (_event, _ctx) => {
		if (!Number.isFinite(TURNS_BETWEEN_TOUCHES) || TURNS_BETWEEN_TOUCHES <= 0) return;
		turnsSinceTouch += 1;
		if (turnsSinceTouch < TURNS_BETWEEN_TOUCHES) return;
		turnsSinceTouch = 0;
		try {
			// Just touch the palace: re-runs status which the next
			// mempal_search can pull from cache.
			await run(["status"], TOUCH_TIMEOUT_MS);
		} catch {
			/* silent */
		}
	});

	pi.on("session_shutdown", async (_event, ctx) => {
		if (!INGEST_ON_SHUTDOWN) return;
		try {
			const wing = wingForDirectory(ctx.cwd);
			// Mine the session transcripts for this cwd. Pi stores them in
			// `$HOME/.pi/agent/sessions/<encoded-cwd>/*.jsonl`. Mempal
			// ingest walks any dir and dedupes by content hash, so this is
			// safe to re-run on every shutdown.
			const sessionDir = sessionDirFor(ctx.cwd);
			await run(["ingest", sessionDir, "--wing", wing, "--no-gitignore", "--no-mempalignore"], INGEST_TIMEOUT_MS);
		} catch {
			/* silent */
		}
	});

	pi.registerCommand("mempal-mine-sessions", {
		description:
			"Mempal: ingest the pi session transcripts for the current cwd into its wing.",
		handler: async (_args, ctx) => {
			const sessionDir = sessionDirFor(ctx.cwd);
			const wing = wingForDirectory(ctx.cwd);
			await run(["ingest", sessionDir, "--wing", wing, "--no-gitignore", "--no-mempalignore"], INGEST_TIMEOUT_MS);
			if (ctx.hasUI) ctx.ui.notify(`Mempal: mined sessions from '${sessionDir}' into wing '${wing}'.`, "info");
		},
	});

	pi.registerCommand("mempal-ingest", {
		description:
			"Mempal: ingest the current working directory into its wing now.",
		handler: async (_args, ctx) => {
			const dir = ctx.cwd;
			const wing = wingForDirectory(dir);
			await run(["ingest", dir, "--wing", wing], INGEST_TIMEOUT_MS);
			if (ctx.hasUI) ctx.ui.notify(`Mempal: ingested '${dir}' into wing '${wing}'.`, "info");
		},
	});

	pi.registerCommand("mempal-init", {
		description: "Mempal: initialize the current working directory as a new wing.",
		handler: async (_args, ctx) => {
			const dir = ctx.cwd;
			const wing = wingForDirectory(dir);
			const known = await wingKnown(wing);
			if (known) {
				if (ctx.hasUI) ctx.ui.notify(`Mempal: wing '${wing}' already exists.`, "info");
				return;
			}
			didInitThisSession = true;
			await run(["init", dir, "--wing", wing], 120_000);
			if (ctx.hasUI) ctx.ui.notify(`Mempal: initialized wing '${wing}'.`, "info");
		},
	});
}
