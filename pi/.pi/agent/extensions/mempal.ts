/**
 * MemPal extension for Pi.
 *
 * Registers `mempal serve --mcp` as a native MCP server. Pi namespaces
 * the tools as `mcp__mempal__*` automatically (codemode exposure), and
 * the MEMORY PROTOCOL arrives via the server's initialize.instructions.
 *
 * Override the binary with MEMPAL_BIN. Default: `$HOME/.cargo/bin/mempal`.
 */
import * as os from "node:os";
import * as path from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const MEMPAL = process.env.MEMPAL_BIN || path.join(os.homedir(), ".cargo", "bin", "mempal");

export default async function mempalExtension(pi: ExtensionAPI) {
	// Native MCP server: `mempal serve --mcp` runs stdio. Pi owns lifetime.
	pi.registerMcpServer("mempal", {
		command: MEMPAL,
		args: ["serve", "--mcp"],
		exposure: "codemode",
		description: "Mempal project memory: semantic recall, knowledge graph, cross-wing tunnels.",
		timeout: 120,
	});
}
