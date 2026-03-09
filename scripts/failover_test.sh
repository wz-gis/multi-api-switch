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
# We use sed to replace the key of the first profile with a broken one.
# This assumes google:profile_new is the first profile as set in SKILL.md.
echo "🧨 Temporarily invalidating the primary key (google:profile_new)..."
sed -i 's/"key": "AIzaSyA8FIfqBx4gKVLFmAzAbym2zDbt4y3LfKA"/"key": "BROKEN-AIzaSyA8FIfqBx4gKVLFmAzAbym2zDbt4y3LfKA"/' "$PROFILES_FILE"

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
