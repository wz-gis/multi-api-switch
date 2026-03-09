# Supported Multi-API Providers

OpenClaw supports multi-API rotation for various providers through its `auth.order` mechanism.

## Google (Generative Language)
- **Primary Model**: `google/gemini-3-flash-preview`
- **TPM Management**: Use multiple profiles if you frequently hit 429 (Too Many Requests) on a single key.

## OpenAI
- **Primary Model**: `openai/gpt-4o`
- **TPM Management**: Useful for separating usage by project or using multiple organization keys to bypass organization-level tier limits.

## MiniMax
- **Primary Model**: `minimax/abab6.5s-chat`
- **TPM Management**: Essential for production stability where rate limits are tight.

## How to add more providers
Simply add a new key under `auth.order` in `openclaw.json` with a list of profiles you've defined in `auth.profiles`.

```json
"auth": {
  "order": {
    "anthropic": ["anthropic:main", "anthropic:backup"]
  }
}
```
