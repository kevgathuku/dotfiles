/**
 * MemPal extension for Pi.
 *
 * Registers `mempal serve --mcp` as a native MCP server. Pi namespaces
 * the tools as `mcp__mempal__*` automatically (codemode exposure), and
 * the MEMORY PROTOCOL arrives via the server's initialize.instructions.
 *
 * Override the binary with MEMPAL_BIN.
 */
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const MEMPAL = process.env.MEMPAL_BIN || "/Users/kevin/.cargo/bin/mempal";

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
