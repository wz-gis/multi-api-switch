#!/bin/bash

# Multi-API Failover Test Script
# Automates the "broken key" test to verify profile rotation.

PROFILES_FILE="/home/node/.openclaw/agents/main/agent/auth-profiles.json"
BACKUP_FILE="/home/node/.openclaw/agents/main/agent/auth-profiles.json.bak"

echo "🔄 Starting Multi-API Failover Test..."

# 1. Backup
echo "📦 Backing up profiles to $BACKUP_FILE..."
cp "$PROFILES_FILE" "$BACKUP_FILE"

# 2. Invalidate first key (example for google:profile_new)
# This assumes google:profile_new is the first profile as set in SKILL.md.
echo "🧨 Temporarily invalidating the primary key..."
# Using a generic pattern to invalidate the first API key found
sed -i '0,/"key": "[^"]*"/{s/"key": "[^"]*"/"key": "BROKEN-KEY"/}' "$PROFILES_FILE"

# 3. Reload secrets
echo "📡 Reloading secrets..."
openclaw secrets reload

# 4. Attempt a ping
echo "📨 Attempting to send a ping message through the gateway..."
RESULT=$(openclaw agent --message "ping" --to main 2>&1)

if [[ $RESULT == *"pong"* ]]; then
    echo "✅ SUCCESS: Primary key failed but fallback key responded with 'pong'!"
else
    echo "❌ FAIL: Fallback key did not respond correctly. Result: $RESULT"
fi

# 5. Restore
echo "🩹 Restoring original profiles..."
mv "$BACKUP_FILE" "$PROFILES_FILE"
openclaw secrets reload

echo "🏁 Test complete."
