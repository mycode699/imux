# Notifications

`icc` includes an in-app notification system for agent workflows. It works well for Claude Code, Codex, OpenCode, and any other tool that can run a shell command when attention is required.

Compatibility note:

- The user-facing CLI is `icc`.
- Some environment variables still use legacy `CMUX_*` names for compatibility.

## Quick start

```bash
command -v icc >/dev/null 2>&1 \
  && icc notify --title "Done" --body "Task complete" \
  || osascript -e 'display notification "Task complete" with title "Done"'
```

## CLI examples

```bash
icc notify --title "Build complete"
icc notify --title "Claude Code" --subtitle "Permission" --body "Approval needed"
icc list-notifications
icc clear-notifications
```

You can also target a specific workspace or surface:

```bash
icc notify --title "Review needed" --workspace workspace:2 --surface surface:1
```

## Claude Code hook

Add a shell hook that prefers `icc` and falls back to macOS notifications:

```json
{
  "hooks": {
    "Notification": [
      {
        "matcher": "idle_prompt",
        "hooks": [
          {
            "type": "command",
            "command": "command -v icc >/dev/null 2>&1 && icc notify --title 'Claude Code' --body 'Waiting for input' || osascript -e 'display notification \"Waiting for input\" with title \"Claude Code\"'"
          }
        ]
      }
    ]
  }
}
```

## Codex hook

`~/.codex/config.toml` example:

```toml
notify = ["bash", "-lc", "MSG=$(echo \"$1\" | jq -r '.\"last-assistant-message\" // \"Turn complete\"' 2>/dev/null | head -c 100); command -v icc >/dev/null 2>&1 && icc notify --title 'Codex' --body \"$MSG\" || osascript -e \"display notification \\\"$MSG\\\" with title \\\"Codex\\\"\"", "--"]
```

## OpenCode plugin sketch

```javascript
export const IccNotificationPlugin = async ({ $, }) => {
  const notify = async (title, body) => {
    try {
      await $`command -v icc >/dev/null 2>&1 && icc notify --title ${title} --body ${body}`;
    } catch {
      await $`osascript -e ${"display notification \"" + body + "\" with title \"" + title + "\""}`;
    }
  };

  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        await notify("OpenCode", "Session idle");
      }
    },
  };
};
```

## Environment variables

`icc` still injects the following compatibility variables into managed child shells:

| Variable | Description |
| --- | --- |
| `CMUX_SOCKET_PATH` | Path to the local control socket |
| `CMUX_WORKSPACE_ID` | UUID of the current workspace |
| `CMUX_PANEL_ID` | UUID of the current panel |
| `CMUX_TAB_ID` | UUID of the current surface/tab |
| `CMUX_PORT` | Start of the workspace port range |
| `CMUX_PORT_END` | End of the workspace port range |

## Best practices

- Always check `command -v icc` before calling it from a shared dotfile.
- Keep titles short and move extra context into the body.
- Use macOS fallback notifications when `icc` is not installed in `PATH`.
