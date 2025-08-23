#!/usr/bin/env bash
PROTOCOLS=(
    "https://github.com/makerdao/dss"
    "https://github.com/compound-finance/compound-protocol"
    "https://github.com/Uniswap/v3-core"
)

for repo in "${PROTOCOLS[@]}"; do
    name=$(basename $repo)
    if [ ! -d "$BUGBASE/targets/monitoring/$name" ]; then
        git clone $repo "$BUGBASE/targets/monitoring/$name"
    else
        cd "$BUGBASE/targets/monitoring/$name"
        git fetch
        NEW_COMMITS=$(git log HEAD..origin/main --oneline)
        if [ ! -z "$NEW_COMMITS" ]; then
            echo "🔔 Novos commits em $name:"
            echo "$NEW_COMMITS"
            git pull
            slither . --print human-summary > /tmp/scan-$name.txt
            osascript -e "display notification \"$name tem updates!\" with title \"Bug Bounty Alert\""
        fi
    fi
done
