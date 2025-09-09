#!/usr/bin/env bash
set -euo pipefail
# Placeholder simples: anexa links de bounty aos alvos já existentes
in="$(git rev-parse --show-toplevel)/bounty-pocs/recon/targets.enriched.json"
out="$(git rev-parse --show-toplevel)/bounty-pocs/recon/programs.json"

python3 - <<'PY' "$in" "$out"
import sys, json, time
with open(sys.argv[1]) as f:
    data = json.load(f)
for t in data["targets"]:
    t.setdefault("bounty", {"platform":"Immunefi","range_usd":"variable","url":t.get("bounty_url","")})
data["programs_updated_at"] = int(time.time())
with open(sys.argv[2], "w") as w:
    json.dump(data, w, indent=2)
print(f"[ok] wrote {sys.argv[2]}")
PY
