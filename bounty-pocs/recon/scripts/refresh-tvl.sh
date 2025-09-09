#!/usr/bin/env bash
set -euo pipefail
# Dummy: só marca prioridade por TVL (se quiser, depois integre DefiLlama API)
targets_file="$(git rev-parse --show-toplevel)/bounty-pocs/recon/targets.yml"
out="$(git rev-parse --show-toplevel)/bounty-pocs/recon/targets.enriched.json"

python3 - <<'PY' "$targets_file" "$out"
import sys, yaml, json, time
with open(sys.argv[1]) as f:
    data = yaml.safe_load(f)
for t in data:
    tvl = float(t.get("tvl_usd", 0))
    t["priority"] = "HIGH" if tvl >= 1e8 else ("MEDIUM" if tvl >= 1e7 else "LOW")
t = {"generated_at": int(time.time()), "targets": data}
with open(sys.argv[2], "w") as w:
    json.dump(t, w, indent=2)
print(f"[ok] wrote {sys.argv[2]}")
PY
