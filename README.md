# 🐺 Bug Bounty Machine – Guia Definitivo

## 📌 Contexto

* Projeto: **web3-security-toolkit / bounty-pocs**
* Objetivo: Criar uma **máquina de caçar bug bounties** em protocolos DeFi/Web3
* Ferramentas principais: Foundry, Anvil, Cast, Python, Bash, GitHub Actions

---

# 🔹 Setup Completo

## 1. Instalação do ambiente

```bash
brew install foundry rust node jq coreutils python3 git gnu-sed
foundryup
pip3 install pyyaml
```

Ferramentas:

* `forge` → compila e testa contratos
* `anvil` → simula blockchains locais
* `cast` → interage com a blockchain

---

## 2. Estrutura do repositório

```
bounty-pocs/
  ├─ src/targets/          # exploits e interfaces
  ├─ test/targets/         # testes Foundry
  ├─ recon/                # scripts de recon
  ├─ reports/              # relatórios
  ├─ research/             # análises
  ├─ private/, credentials/ # dados sensíveis
  └─ scripts/              # automações
```

---

## 3. Proteção de arquivos sensíveis

Arquivo `.gitignore` deve conter:

```
.env
private/
credentials/
reports/
out/
cache/
.DS_Store
```

---

## 4. Recon Pipeline

Scripts:

* `refresh-tvl.sh` → lê `targets.yml`, gera `targets.enriched.json`
* `fetch-programs.sh` → enriquece com dados de bounty

Execução:

```bash
make recon
```

---

## 5. Exemplo de `targets.yml`

```yaml
- name: Curve
  chain: ethereum
  tvl_usd: 2200000000
  bounty_url: https://immunefi.com/bounty/curve
  last_audit: "2023-12-15"
  rpc_url: ${RPC_MAINNET}
```

---

## 6. CI/CD (GitHub Actions)

1. Criar **Personal Access Token (classic)** com permissão `repo`.
2. Salvar no GitHub Secrets como `PAT_TOKEN`.
3. Workflow usa:

```yaml
git push https://x-access-token:${{ secrets.PAT_TOKEN }}@github.com/${{ github.repository }}.git HEAD:${{ github.ref }}
```

---

## 7. Foundry Setup

Arquivo `foundry.toml`:

```toml
[profile.default]
src = "src"
test = "bounty-pocs/test"
out = "out"
libs = ["lib"]
ffi = true
optimizer = true
optimizer_runs = 200

remappings = [
  "forge-std/=lib/forge-std/src/"
]

[rpc_endpoints]
mainnet  = "${RPC_MAINNET}"
optimism = "${RPC_OPTIMISM}"
arbitrum = "${RPC_ARBITRUM}"
```

Instalação de libs:

```bash
forge install foundry-rs/forge-std
```

---

## 8. Configuração de RPCs

Arquivo `.env`:

```ini
# ==== RPC URLs ====
RPC_MAINNET=https://eth-mainnet.g.alchemy.com/v2/<API_KEY>
RPC_OPTIMISM=https://opt-mainnet.g.alchemy.com/v2/<API_KEY>
RPC_ARBITRUM=https://arb-mainnet.g.alchemy.com/v2/<API_KEY>

# ==== API Keys (opcional) ====
ETHERSCAN_API_KEY=
POLYGONSCAN_API_KEY=
ARBISCAN_API_KEY=
```

Carregar variáveis:

```bash
source .env
```

---

## 9. Exploits e Testes

* Criar exploits em `src/targets/`
* Testes em `test/targets/` com `Exploit.t.sol`
* Rodar com:

```bash
forge test --fork-url $RPC_MAINNET --fork-block-number <BLOCK> -vvvv
```

---

## 10. Próximos Passos

* Corrigir endereços de targets no Alchemix
* Expandir exploit no Curve com `deal()` para seed de DAI/USDC/USDT
* Testar Wormhole com verificação de assinaturas/replays
* Integrar geração automática de relatórios

---

# 🚀 Comandos Rápidos

```bash
# Recon pipeline
make recon

# Fork mainnet em bloco específico
forge test --fork-url $RPC_MAINNET --fork-block-number <BLOCK> -vvvv

# Rodar só Curve
forge test -vvvv --match-path test/targets/curve/Exploit.t.sol
```

---


> “Cada linha de código tem um preço — encontre antes que outro ache.”

---
