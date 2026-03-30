# CLAUDE.md

Global guidance for Claude Code across all projects.

## Project Conventions

- Follow existing patterns in the codebase for consistency (e.g., path construction methods)

## Development Tools & Git

- For long git commit messages in zsh, use temp file method: `cat > /tmp/msg.txt << 'EOF' ... EOF` then `git commit -F /tmp/msg.txt` to avoid heredoc parsing issues

@RTK.md
