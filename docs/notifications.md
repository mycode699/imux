# Notifications

`imux` includes an in-app notification system for agent workflows. It works well for Claude Code, Codex, OpenCode, and any other tool that can run a shell command when attention is required.

Compatibility note:

- The user-facing CLI is `imux`.
- Some environment variables still use legacy `ICC_*` names for compatibility.

## Quick start

```bash
command -v imux >/dev/null 2>&1 \
  && imux notify --title "Done" --body "Task complete" \
  || osascript -e 'display notification "Task complete" with title "Done"'
```

## CLI examples

```bash
imux notify --title "Build complete"
imux notify --title "Claude Code" --subtitle "Permission" --body "Approval needed"
imux list-notifications
imux clear-notifications
```

You can also target a specific workspace or surface:

```bash
imux notify --title "Review needed" --workspace workspace:2 --surface surface:1
```

## Claude Code hook

Add a shell hook that prefers `imux` and falls back to macOS notifications:

```json
{
  "hooks": {
    "Notification": [
      {
        "matcher": "idle_prompt",
        "hooks": [
          {
            "type": "command",
            "command": "command -v imux >/dev/null 2>&1 && imux notify --title 'Claude Code' --body 'Waiting for input' || osascript -e 'display notification \"Waiting for input\" with title \"Claude Code\"'"
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
notify = ["bash", "-lc", "MSG=$(echo \"$1\" | jq -r '.\"last-assistant-message\" // \"Turn complete\"' 2>/dev/null | head -c 100); command -v imux >/dev/null 2>&1 && imux notify --title 'Codex' --body \"$MSG\" || osascript -e \"display notification \\\"$MSG\\\" with title \\\"Codex\\\"\"", "--"]
```

## OpenCode plugin sketch

```javascript
export const ImuxNotificationPlugin = async ({ $, }) => {
  const notify = async (title, body) => {
    try {
      await $`command -v imux >/dev/null 2>&1 && imux notify --title ${title} --body ${body}`;
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

`imux` injects primary `IMUX_*` variables into managed child shells and still mirrors the legacy `ICC_*` names for compatibility:

| Variable | Description |
| --- | --- |
| `IMUX_SOCKET_PATH` | Path to the local control socket |
| `IMUX_WORKSPACE_ID` | UUID of the current workspace |
| `IMUX_PANEL_ID` | UUID of the current panel |
| `IMUX_TAB_ID` | UUID of the current surface/tab |
| `IMUX_PORT` | Start of the workspace port range |
| `IMUX_PORT_END` | End of the workspace port range |

## Best practices

- Always check `command -v imux` before calling it from a shared dotfile.
- Keep titles short and move extra context into the body.
- Use macOS fallback notifications when `imux` is not installed in `PATH`.
