# Multi-API Switch & Rotation Skill for OpenClaw

A specialized skill for managing high-availability API rotation and failover across multiple providers (Google, OpenAI, MiniMax, etc.) within OpenClaw.

## Overview

This skill allows you to:
- **Configure Multi-API Rotation**: Setup and manage `auth.order` in `openclaw.json` and key storage in `auth-profiles.json`.
- **Automated Failover Testing**: Use a script to verify your rotation setup by simulating "broken" keys.
- **Provider-Level Rotation**: Efficiently switch between different API profiles to bypass individual key rate limits (TPM).

## Quick Start

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
    "google:profile1": { "type": "api_key", "provider": "google", "key": "YOUR_API_KEY_1" },
    "google:profile2": { "type": "api_key", "provider": "google", "key": "YOUR_API_KEY_2" }
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
2. Temporarily invalidates the primary key.
3. Reloads secrets and attempts a simple "ping" message.
4. Verifies that the second key successfully handles the request.
5. Restores the original configuration.

## Supported Providers

| Provider | Primary Model | Purpose |
| :--- | :--- | :--- |
| **Google** | `google/gemini-3-flash-preview` | High TPM, low latency |
| **OpenAI** | `openai/gpt-4o` | Versatile, high intelligence |
| **MiniMax** | `minimax/abab6.5s-chat` | Stability and reliability |

## Manual Switching

To force a specific profile for the current session:
- Use `/model <model_name>@<profile_id>`
- Example: `/model gemini-3-flash-preview@google:profile_old`

---
*Created and maintained with OpenClaw.*
