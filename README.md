
# 🐺 Bug Bounty Machine – Guia Definitivo e Análise Arquitetural

## 📌 Visão Geral

Este repositório, **web3-security-toolkit**, é um sistema integrado e de nível profissional para a caça sistemática de bug bounties em protocolos DeFi/Web3. Ele foi projetado com uma filosofia de **automação, reprodutibilidade e metodologia**, transformando o processo de caça de bugs de uma arte para uma ciência de engenharia.

As ferramentas principais que orquestram este sistema são Foundry (Anvil, Forge, Cast), Python, Bash e GitHub Actions.

-----

## 🔹 Módulo 1: Setup e Configuração do Ambiente

Para operar a máquina, o setup inicial correto é crucial.

### 1\. Instalação de Dependências

O ambiente é baseado em um conjunto de ferramentas padrão da indústria.

```bash
# Instalação via Homebrew (macOS) ou gerenciador de pacotes equivalente
brew install foundry rust node jq coreutils python3 git gnu-sed

# Atualiza o Foundry para a última versão
foundryup

# Instala a dependência Python para o pipeline de recon
pip3 install pyyaml
```

  * `forge` → compila e testa contratos.
  * `anvil` → simula blockchains locais (forking).
  * `cast` → interage com a blockchain via linha de comando.

### 2\. Configuração de RPCs e Chaves de API (`.env`)

Crie um arquivo `.env` na raiz para armazenar suas chaves privadas. Este arquivo é ignorado pelo Git para sua segurança.

```ini
# ==== RPC URLs (obrigatório para forking) ====
RPC_MAINNET=https://eth-mainnet.g.alchemy.com/v2/SUA_API_KEY
RPC_OPTIMISM=https://opt-mainnet.g.alchemy.com/v2/SUA_API_KEY
RPC_ARBITRUM=https://arb-mainnet.g.alchemy.com/v2/SUA_API_KEY

# ==== API Keys (opcional) ====
ETHERSCAN_API_KEY=
```

**Para carregar as variáveis no seu terminal, use:** `source .env`.

### 3\. Análise dos Arquivos de Configuração

  * **`.gitignore`**: Essencial para a segurança operacional (OpSec). Impede que arquivos sensíveis como `.env`, chaves (`*.key`), relatórios privados e diretórios de build (`out/`, `cache/`) sejam enviados para o GitHub.
  * **`.gitmodules`**: Define as dependências do projeto (ex: `forge-std`, `openzeppelin-contracts`) como submódulos do Git. Isso mantém o repositório limpo e facilita a atualização das dependências.
  * **`foundry.lock`**: Grava a versão exata (commit hash) de cada dependência. Isso garante a reprodutibilidade dos testes, evitando que atualizações inesperadas nas bibliotecas quebrem seus exploits.
  * **`.gitattributes`**: Define atributos para caminhos de arquivos, garantindo que o GitHub renderize a sintaxe do Solidity corretamente e marque os diretórios de build como gerados.
  * **`foundry.toml`**: Arquivo de configuração principal do Foundry. Define os diretórios padrão, habilita o `ffi` (permitindo que testes executem comandos de shell), `fs_permissions` (permitindo acesso ao sistema de arquivos) e mapeia os `rpc_endpoints` para as variáveis de ambiente.
  * **`bounty-pocs/remappings.txt`**: Mapeia prefixos de importação para caminhos de bibliotecas, tornando as importações de Solidity mais limpas e portáveis (ex: `@openzeppelin/` em vez de `../lib/openzeppelin-contracts/`).

-----

## Módulo 2: O Pipeline de Reconhecimento (Recon)

Este é o coração do sistema de automação. Ele transforma uma simples lista de alvos em uma base de dados enriquecida e priorizada.

**Fluxo de Trabalho:** `targets.yml` → `make recon` → `targets.enriched.json` → `programs.json`

### 1\. O Orquestrador e o Piloto Automático

  * **`Makefile`**: Simplifica a execução do pipeline em um único comando (`make recon`). Ele serve como o maestro, chamando os scripts de enriquecimento na ordem correta.
  * **`.github/workflows/recon.yml`**: Coloca o pipeline no piloto automático. Este workflow do GitHub Actions executa `make recon` em horários agendados (`cron`) e, se houver qualquer alteração nos arquivos JSON, um "Recon Bot" commita as atualizações de volta para o repositório.

### 2\. Análise dos Scripts de Recon

  * **`bounty-pocs/recon/targets.yml`**: A "fonte da verdade" manual. É aqui que você define seus alvos, incluindo nome, TVL, URL do bounty e notas. O uso de variáveis como `${RPC_MAINNET}` permite configuração dinâmica.
  * **`refresh-tvl.sh`**: Lê `targets.yml`, e usando um script Python embutido, adiciona um campo `"priority"` (`HIGH`, `MEDIUM`, `LOW`) baseado no TVL, gerando o arquivo `targets.enriched.json`.
  * **`fetch-programs.sh`**: Lê `targets.enriched.json`, adiciona informações padronizadas sobre o programa de bounty (ex: plataforma Immunefi) e gera o arquivo final `programs.json`.
  * **`_common_json.py`**: Um módulo Python auxiliar com funções robustas para manipulação segura de JSON, como `to_float_safe` que previne erros de conversão de tipos.
  * **`diff-upgrades.sh`**: Uma ferramenta de nível avançado para monitorar upgrades de contratos proxy (padrão EIP-1967), lendo o endereço de implementação do `storage slot` específico.

-----

## Módulo 3: O Fluxo de Trabalho da Caça

Com o ambiente configurado e os alvos priorizados, o ciclo de caça pode começar.

### 1\. Scripts de Automação e Produtividade

  * **`new-target.sh`**: Cria toda a estrutura de arquivos (diretórios, templates de `Exploit.sol`, `Exploit.t.sol` e `README.md`) para um novo alvo com um único comando, padronizando seu fluxo de trabalho.
  * **`daily.sh`**: Um script de "preparação diária" que garante que seu ambiente esteja pronto para o alvo do dia e registra a atividade em um `kpi.log` para rastreamento de esforço.
  * **`update-kpis.py`**: Lê o `kpi.log` e gera um resumo de quantas vezes você trabalhou em cada alvo, útil para autoavaliação.

### 2\. Forking e Testes

O núcleo da caça é testar exploits contra o estado real da blockchain em um ambiente local seguro.

1.  **Inicie o Fork (`fork.sh`):** Em um terminal, inicie uma simulação local da mainnet a partir de um bloco específico.
    ```bash
    BLOCK=19000000 ./bounty-pocs/scripts/fork.sh mainnet
    ```
2.  **Execute os Testes (`run-tests.sh`):** Em outro terminal, use este script que faz verificações de segurança (ex: chain-id) para garantir que você está conectado ao fork local e não à mainnet real, antes de executar `forge test`.
    ```bash
    forge test --match-path test/targets/curve/Exploit.t.sol -vvvv
    ```

### 3\. Exemplo Prático: PoC do Aave Flashloan

O arquivo `reports/aave_poc.md` documenta um caso de uso real deste sistema. Ele demonstra a capacidade de pegar um empréstimo instantâneo (`flashloan`) de **1.000.000 DAI** do protocolo Aave, executar uma lógica, pagar o empréstimo mais a taxa na mesma transação e verificar o resultado, tudo dentro de um teste Foundry.

-----

## Módulo 4: Análise de Impacto e Relatórios

Encontrar um bug é metade da batalha. Quantificar o impacto e reportá-lo profissionalmente é o que garante as maiores recompensas.

### 1\. Ferramentas de Análise de Impacto (`bounty-pocs/impact/`)

  * **`templates/impact.md`**: Um checklist para garantir uma análise completa, cobrindo fundos, insolvência, governança e efeitos em cascata.
  * **Calculadoras Python:**
      * `funds-at-risk.py`: Calcula o valor total em dólares dos fundos em risco a partir de um input JSON.
      * `insolvency-sim.py`: Simula se a perda causada pelo seu exploit levaria o protocolo a um estado de insolvência.

### 2\. Templates e Geração de Relatórios

  * **`reports/templates/immunefi.md`**: Um template de relatório profissional formatado para plataformas como a Immunefi, com todas as seções necessárias para um reporte de alta qualidade.
  * **`scripts/gen_report.py`**: Um script de utilidade para gerar um resumo em Markdown a partir dos seus arquivos JSON de recon, útil para ter uma visão geral do seu progresso.

-----

## 🚀 Roteiro de Caça Real – Bug Bounty DeFi

Você já tem a infraestrutura. Agora, como transformar isso em $$ em bug bounty real?

1.  **Escolha o Alvo Certo:** Vá em **[Immunefi](https://immunefi.com/explore/)** e filtre por TVL alto, recompensa máxima alta (\>= $1M USD) e protocolos com oráculos, bridges ou flashloans.
2.  **Recon Inteligente:** Use seu `targets.yml` e `make recon` para organizar os contratos em escopo e ter uma lista clara de alvos com endereços e RPCs prontos para o fork.
3.  **Reprodução em Fork:** Foque em vetores de ataque de alto impacto como manipulação de oráculos, falhas em bridges (replay attacks) e liquidações forçadas via flashloans.
4.  **Criar PoCs:** Documente cada tentativa, mesmo que não seja um bug, usando o formato do seu `reports/aave_poc.md`. Isso cria uma biblioteca de exploits reutilizáveis.
5.  **Escalada para $$$:** Quando encontrar uma falha que quebra as invariantes do protocolo, confirme em forks diferentes, documente usando seu template `immunefi.md` e envie no formulário oficial da plataforma.

**Dicas de Sobrevivência:**

  * **Foque em poucos alvos, mas profundos.**
  * **Automatize seus scans e monitoramento.**
  * **Reporte rápido.** O primeiro a reportar leva a recompensa.
  * **Documente tudo com clareza.**

O próximo passo é pegar um alvo real, preparar seu `targets.yml`, rodar um fork e começar a testar até quebrar algo.

> “Cada linha de código tem um preço — encontre antes que outro ache.”