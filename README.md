
# Setup Bug Bounty – Linha do Tempo Explicada

---

## 1. Preparação do ambiente

### O que foi feito
```bash
brew install foundry rust node jq coreutils
foundryup
````

Ferramentas disponíveis:

* `forge` → compila e testa contratos
* `anvil` → simula/forka blockchains
* `cast` → interage com a blockchain

### Por que importa

Essas três ferramentas são o **kit essencial do hunter**.
Permitem controle total sobre a blockchain, direto no seu laptop.

---

## 2. Estrutura do repositório

```
src/targets/      # contratos exploit
test/targets/     # testes dos exploits
targets/          # docs README por alvo
scripts/          # automações (fork, run-tests, new-target)
reports/          # relatórios (draft/submitted)
research/         # notas e análises
private/          # itens privados
credentials/      # RPCs, chaves, segredos
```

### Por que importa

Organização acelera o fluxo.
Cada alvo fica isolado, documentado e replicável.

---

## 3. Proteção de arquivos sensíveis

`.gitignore` configurado para ignorar:

* `.env`
* `private/`, `credentials/`
* `reports/`
* `out/`, `cache/`
* `.DS_Store`

### Por que importa

Evita expor chaves privadas e RPCs pagos.
Protege credibilidade e segurança.

---

## 4. Configuração de RPCs

Arquivo `.env`:

```ini
RPC_MAINNET=...
RPC_OPTIMISM=...
RPC_ARBITRUM=...
```

### Por que importa

RPC é a ponte entre fork e blockchain real.
Permite reproduzir o **estado exato da rede**.

---

## 5. Arquivo `foundry.toml`

```toml
[profile.default]
src = "src"
out = "out"
libs = ["lib"]
ffi = true
optimizer = true
optimizer_runs = 200

[rpc_endpoints]
mainnet  = "${RPC_MAINNET}"
optimism = "${RPC_OPTIMISM}"
arbitrum = "${RPC_ARBITRUM}"
```

### Por que importa

Centraliza configs, conecta ao `.env`
Facilita troca de rede com um comando.

---

## 6. Scripts de automação

* **`fork.sh`**

  ```bash
  BLOCK=123456789 ./scripts/fork.sh optimism
  ```
* **`run-tests.sh`** → roda testes no fork (valida chain-id 10)
* **`new-target.sh`** → scaffolding automático de exploits

### Por que importa

Automação reduz fricção.
Novo alvo = 3 comandos → contrato, teste e README prontos.

---

## 7. Dependências

Instalado:

```bash
forge install foundry-rs/forge-std
```

### Por que importa

* Acesso a `Test.sol` (asserts/logs)
* Padrão reconhecido em auditorias e bug bounties

---

## 8. Primeiro alvo: Alchemix TransmuterEth

Criado com:

```bash
./scripts/new-target.sh alchemix-transmuter
```

Gerou:

* `Exploit.sol`
* `Exploit.t.sol`
* `README.md`

### Por que importa

Primeiro caso real em Optimism.
Ambiente de caça vivo, não apenas exemplo.

---

## 9. Teste de sanidade

Exemplo:

```solidity
address constant TARGET = 0xb7C4250f83289ff3Ea9f21f01AAd0b02fb19491a;
```

Testa:

* `chainid`
* endereço do contrato
* saldo ETH

### Por que importa

Confirma fork correto, contrato correto, snapshot correto.

---

## 10. Debug avançado: Proxy e Buffer

* TransmuterEth = **proxy EIP-1967**
* Aponta para um `buffer()` que guarda fundos
* Buffer também é proxy
* Saldo encontrado: \~**1.302 WETH**

### Por que importa

Investigar além do “saldo 0” → achamos onde os fundos realmente estão.
Esse é o diferencial de hunters de elite.

---

# Estado Atual

* Ambiente instalado ✔️
* Repositório estruturado ✔️
* RPCs configurados ✔️
* Scripts de automação funcionando ✔️
* Primeiro alvo scaffoldado ✔️
* Sanity test validado ✔️
* Proxy e buffer investigados ✔️
* **1.302 WETH localizados no buffer ✔️**

---

# Próximo Objetivo

* Mapear **quem consegue mover os WETH** do buffer (owner, router, roles).
* Escrever o **`test_Exploit()`** com fluxo onde atacante ganha.

---

# Smoke Tests Rápidos

```bash
# Fork da OP no bloco desejado
BLOCK=123456789 ./scripts/fork.sh optimism

# Sanidade do RPC
cast chain --rpc-url http://127.0.0.1:8545
cast rpc eth_chainId --rpc-url http://127.0.0.1:8545

# Testes no fork
RPC_URL=http://127.0.0.1:8545 BLOCK=123456789 ./scripts/run-tests.sh
```

---

# Upgrades Recomendados

* **Snapshot rápido no Anvil**: usar `--no-rate-limit --auto-impersonate` no `fork.sh`.
* **Guardas de CI local**: script `check.sh` rodando build + sanity + teste curto antes de commit.

---
```
 🎯 Target escolhido
        │
        ▼
┌─────────────────────┐
│ research/targets/   │  ← Estudo inicial (README, notas, blocos)
└─────────────────────┘
        │
        ▼
┌─────────────────────┐
│ src/targets/        │  ← Exploit.sol + interfaces mínimas
└─────────────────────┘
        │
        ▼
┌─────────────────────┐
│ test/targets/       │  ← Testes Foundry (Sanity + Exploit.t.sol)
└─────────────────────┘
        │
        ▼
⚙️ forge test / anvil fork
        │
        ▼
┌─────────────────────┐
│ out/                │  ← Artefatos (ABI, bytecode, traces, logs)
└─────────────────────┘
        │
        ▼
📑 Validação automática (logs + balances)
        │
        ▼
┌─────────────────────┐
│ reports/draft/      │  ← Relatório inicial (auto-gerado)
└─────────────────────┘
        │
        ▼
👨‍💻 Revisão humana + IA (Guardião + Redator)
        │
        ▼
┌─────────────────────┐
│ reports/submitted/  │  ← Relatório final enviado (Immunefi)
└─────────────────────┘
        │
        ▼
💰 Recompensa no bolso
