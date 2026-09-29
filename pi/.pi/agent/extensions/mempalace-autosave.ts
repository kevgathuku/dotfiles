/**
 * MemPalace autosave extension for Pi.
 *
 * Mines the live session transcript into the palace periodically, so
 * decisions made in one-off chats are recorded even when the agent never
 * calls a filing tool. Mirrors the Stop/PreCompact transcript ingest other
 * harnesses get from `mempalace hook run`, mapped onto pi's lifecycle:
 * `turn_end` every N turns plus a final pass on `session_shutdown`.
 *
 * Re-mining is safe: convo completeness tracking skips exchanges already
 * filed, so each pass only files what is new since the last one.
 *
 * Configuration (environment):
 * - MEMPALACE_AUTOSAVE_TURNS (default "10"): mine every N turns. "0" disables
 *   the periodic pass; shutdown mining still runs unless disabled below.
 * - MEMPALACE_AUTOSAVE_ON_SHUTDOWN (default "1"): "0" disables the final pass.
 * - MEMPALACE_AUTOSAVE_WING: wing to file under. Default derives from the
 *   session working directory basename (e.g. torrent-client-clj becomes
 *   torrent_client_clj), matching the hook ingest convention.
 * - MEMPALACE_MCP_COMMAND is not used here; mining goes through the
 *   `mempalace` CLI resolved from PATH.
 *
 * Failures are silent by design: memory must never interrupt the session.
 */

import { execFile } from "node:child_process";
import * as path from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const TURNS_BETWEEN_MINES =
	Number.parseInt(process.env.MEMPALACE_AUTOSAVE_TURNS ?? "10", 10);
const MINE_ON_SHUTDOWN = (process.env.MEMPALACE_AUTOSAVE_ON_SHUTDOWN ?? "1") !== "0";
const MINE_TIMEOUT_MS = 300_000;

function wingForDirectory(dir: string): string {
	const override = process.env.MEMPALACE_AUTOSAVE_WING;
	if (override && override.trim().length > 0) return override.trim();
	const base = path.basename(path.resolve(dir));
	const wing = base.toLowerCase().replace(/[^a-z0-9]+/g, "_");
	return wing.length > 0 ? wing : "general";
}

function runMine(sessionFile: string, wing: string, timeoutMs: number): Promise<void> {
	return new Promise((resolve) => {
		execFile(
			"mempalace",
			["mine", sessionFile, "--mode", "convos", "--wing", wing],
			{ timeout: timeoutMs },
			() => resolve(),
		);
	});
}

export default function mempalaceAutosave(pi: ExtensionAPI) {
	let turnsSinceMine = 0;

	pi.on("turn_end", async (_event, ctx) => {
		if (!Number.isFinite(TURNS_BETWEEN_MINES) || TURNS_BETWEEN_MINES <= 0) return;
		turnsSinceMine += 1;
		if (turnsSinceMine < TURNS_BETWEEN_MINES) return;
		turnsSinceMine = 0;
		try {
			const sessionFile = ctx.sessionManager.getSessionFile();
			if (!sessionFile) return;
			// Fire and forget: awaiting a multi-minute mine here would stall
			// the next turn. runMine never rejects, so this is safe to float.
			void runMine(sessionFile, wingForDirectory(ctx.cwd), MINE_TIMEOUT_MS);
		} catch {
			// Silent: filing must never break the turn.
		}
	});

	pi.on("session_shutdown", async (_event, ctx) => {
		if (!MINE_ON_SHUTDOWN) return;
		try {
			const sessionFile = ctx.sessionManager.getSessionFile();
			if (!sessionFile) return;
			// Awaited but time-boxed: shutdown should not hang indefinitely
			// on a large transcript.
			await runMine(sessionFile, wingForDirectory(ctx.cwd), 120_000);
		} catch {
			// Silent: filing must never break shutdown.
		}
	});

	pi.registerCommand("mine-session", {
		description:
			"Mine the current session transcript into the palace now (convos mode).",
		handler: async (_args, ctx) => {
			const sessionFile = ctx.sessionManager.getSessionFile();
			if (!sessionFile) {
				if (ctx.hasUI) ctx.ui.notify("No session file available.", "error");
				return;
			}
			const wing = wingForDirectory(ctx.cwd);
			await runMine(sessionFile, wing, MINE_TIMEOUT_MS);
			if (ctx.hasUI) ctx.ui.notify(`Mined the session transcript into wing '${wing}'.`, "info");
		},
	});
}
