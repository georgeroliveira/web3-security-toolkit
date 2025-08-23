#!/usr/bin/env bash
echo "🔔 Monitorando novos bounties..."
curl -s https://immunefi.com/bounty/ | grep -o '"slug":"[^"]*"' | cut -d'"' -f4 > /tmp/current-bounties.txt

if [ -f "$BUGBASE/research/last-bounties.txt" ]; then
    diff /tmp/current-bounties.txt "$BUGBASE/research/last-bounties.txt" | grep "^<" | while read new; do
        echo "🆕 Novo bounty: $new"
        osascript -e "display notification \"Novo bounty: $new\" with title \"Bug Bounty Alert\""
    done
fi

mv /tmp/current-bounties.txt "$BUGBASE/research/last-bounties.txt"
