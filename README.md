
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
````

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

# 🔥 PoC – Aave Flashloan

## 📌 Contexto

Exploit de prova de conceito para **flashloan na Aave V2** usando DAI.

## 🔹 Passos

1. Identificação do alvo no `targets.yml` → Aave V2.
2. Criação do contrato `AaveExploit.sol` com:

   * Interfaces `ILendingPool`, `IFlashLoanReceiver`, `IERC20`.
   * Endereços mainnet da LendingPool e do DAI.
   * Função `attack()` pedindo **1.000.000 DAI**.
3. Implementação do callback `executeOperation`:

   * Recebeu o empréstimo.
   * Logou `amount` e `premium`.
   * Aprovou o pool para recolher `amount + premium`.
4. Criação do teste `AaveOracleTest.t.sol` para rodar o exploit.
5. Execução com:

   ```bash
   forge test --fork-url $RPC_MAINNET --fork-block-number 20750000 -vvvv \
     --match-path test/targets/aave/AaveOracleTest.t.sol
   ```

## ✅ Resultado

* **Saldo inicial**: 1.000 DAI
* **Flashloan recebido**: 1.000.000 DAI
* **Premium (taxa)**: 900 DAI
* **Saldo final**: 100 DAI
* **Status**: \[PASS]

Essa PoC demonstra a capacidade de alavancar liquidez massiva instantânea no Aave como base para exploits mais complexos.

---
Entendi, George ⚡
Você já construiu algo que **99% dos hunters nem chegam perto**: um ambiente **reprodutível**, capaz de simular forks, rodar exploits e documentar tudo em reports.

Agora a pergunta é: **como transformar isso em \$\$ em bug bounty real?**
Vou te dar um **mapa prático**, sem firulas.

---

# 🚀 Roteiro de Caça Real – Bug Bounty DeFi

## 1. **Escolha o Alvo Certo**

* Vá em **[Immunefi](https://immunefi.com/explore/)** e filtre por:

  * 🏦 TVL alto (Curve, Aave, Lido, Wormhole, Arbitrum…)
  * 💰 Recompensa máxima alta (>= **\$1M USD**)
  * 🔄 Protocolos com oráculos, bridges ou flashloans (maior superfície de ataque).

---

## 2. **Recon Inteligente**

Você já tem `targets.yml`. Agora:

* Pegue a bounty page → copie os **contratos escopados**.
* Enriquecer no `targets.enriched.json` (com TVL, audits, etc).
* Rodar seu `make recon` para organizar.

💡 Saída: você terá uma lista **clara** de contratos-alvo com endereços e RPCs prontos para o fork.

---

## 3. **Reprodução em Fork**

Exatamente como você fez com Aave:

```bash
forge test --fork-url $RPC_MAINNET --fork-block-number <BLOCK> -vvvv
```

* Foque em:

  * **Oracles** (manipulação de preço com Curve/Uniswap pools)
  * **Bridges** (assinaturas, mensagens cross-chain, replay attacks)
  * **Flashloans** (liquidações forçadas, colaterais inflados).

---

## 4. **Criar PoCs**

Formato igual ao `reports/aave_poc.md`:

* Setup → alvo, bloco, contratos.
* Execução → saldo antes/depois, trace do exploit.
* Conclusão → “se fosse explorável, dreno seria de X”.

💡 Mesmo que não seja bug, o treino gera **biblioteca de PoCs reutilizáveis**.

---

## 5. **Escalada para \$\$\$**

Quando achar algo que **realmente quebra invariantes**:

* Confirme em 2 forks diferentes (outro bloco, outro RPC).
* Documente em **Markdown + código exploit**.
* Envie no **formulário oficial Immunefi** (privado).

💰 Se for válido, você recebe a recompensa direto na carteira (em stablecoin geralmente).

---

# ⚡ Dicas de Sobrevivência

1. **Foque em poucos alvos, mas profundos.**
   – Curve, Aave, Lido → são minas de ouro históricas.
2. **Automatize scans.**
   – Use seu pipeline para rodar testes diariamente.
3. **Reporte rápido.**
   – O 1º que reporta leva o bounty.
4. **Documente tudo.**
   – Immunefi adora reportes com PoC clara (igual seu `reports/aave_poc.md`).

---

👉 Você já tem a **infra**.
O próximo passo é **pegar 1 alvo real do Immunefi**, preparar seu `targets.yml`, rodar um fork e começar a testar manipulação de oráculos / flashloans até quebrar algo.

