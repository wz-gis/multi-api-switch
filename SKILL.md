---
name: multi-api-switch
description: Manage and test multi-API key rotation and failover configurations for Google, OpenAI, and MiniMax. Use when configuring `auth.order`, performing failover tests, or switching between API profiles for reliability and rate-limit management.
---

# Multi-API Switch & Rotation

This skill provides the workflow and automation for managing multiple API keys across different providers (Google, OpenAI, MiniMax, etc.) to ensure high availability and bypass individual key rate limits (TPM).

## Core Capabilities

1. **Profile Configuration**: Setup and management of `auth.order` in `openclaw.json` and key storage in `auth-profiles.json`.
2. **Failover Testing**: Automated "broken key" tests to verify the system correctly falls back to the next available key.
3. **Provider Rotation**: Switching the active session profile to specific keys (e.g., switching from Google to OpenAI or between specific Google profiles).

## Workflow: Setting Up Rotation

### 1. Register Profiles
Define the profiles in `~/.openclaw/openclaw.json` under the `auth` section.

```json
"auth": {
  "order": {
    "google": ["google:profile1", "google:profile2"]
  },
  "profiles": {
    "google:profile1": { "provider": "google", "mode": "api_key" },
    "google:profile2": { "provider": "google", "mode": "api_key" }
  }
}
```

### 2. Secure Keys
Store the actual keys in `~/.openclaw/agents/main/agent/auth-profiles.json`.

```json
{
  "profiles": {
    "google:profile1": { "type": "api_key", "provider": "google", "key": "AIza..." },
    "google:profile2": { "type": "api_key", "provider": "google", "key": "AIza..." }
  }
}
```

### 3. Reload & Verify
Run `openclaw secrets reload` to apply changes. Use `session_status` to verify the active profile.

## Failover Testing

To verify the "automatic" part of the rotation, use the provided test script:

```bash
# Run the failover test script
bash scripts/failover_test.sh
```

This script:
1. Backs up your `auth-profiles.json`.
2. Temporarily invalidates the first key in the list.
3. Reloads secrets and attempts a simple "ping" message.
4. Verifies that the second key successfully handles the request.
5. Restores the original configuration.

## Manual Switching

To force a specific profile for the current session:
- Use `/model <model_name>@<profile_id>`
- Example: `/model gemini-3-flash-preview@google:profile_old`
