# 🏆 Roadmap 30 Dias – Bug Bounty Web3 até $100k

---

## 📅 Semana 1 – Fundamentos + Setup

**Meta:** ambiente pronto + 20 reports críticos estudados.

### Dia 1
- [ ] Criar contas Immunefi, Code4rena, Sherlock, GitHub  
- [ ] Configurar email dedicado + 2FA  
- [ ] Instalar stack (`brew`, `python`, `go`, `foundryup`)  
- [ ] Criar repositório privado `web3-security-toolkit`  
- [ ] Estruturar diretórios `targets/`, `reports/`, `pocs/`, `scripts/`  

### Dia 2
- [ ] Instalar arsenal (`slither`, `echidna`, `mythril`, `manticore`)  
- [ ] Configurar `monitor-bounties.sh` e `smart-monitor.sh`  
- [ ] Rodar `slither .` em contratos simples (ERC20, ERC721)  

### Dia 3
- [ ] Ler 5 reports críticos de **bridges**  
- [ ] Reproduzir 1 PoC no Hardhat fork mainnet  
- [ ] Anotar insights em `research/bridges/`  

### Dia 4
- [ ] Ler 5 reports críticos de **lending protocols**  
- [ ] Reproduzir PoC de manipulação de preço (Compound/Aave)  
- [ ] Escrever mini-report interno (impacto + exploit steps)  

### Dia 5
- [ ] Ler 5 reports de **DEXs** (Uniswap/Curve)  
- [ ] Rodar `deep-scan.sh` em repo da Curve  
- [ ] Checklist de vulnerabilidades comuns (reentrância, rounding, init sem controle)  

### Dia 6
- [ ] Ler 5 reports de **L2s/Rollups**  
- [ ] Reproduzir PoC de replay em bridge/L2  
- [ ] Consolidar 20 reports estudados em tabela  

### Dia 7
- [ ] Revisar setup + corrigir scripts  
- [ ] Escrever **1 report de treino** (mesmo bug público)  
- [ ] Networking no Discord Immunefi  

---

## 🚀 Semana 2 – Primeiras Caçadas Reais

**Meta:** enviar 1-2 reports medium/high ($500-$5k).

### Dia 8
- [ ] Escolher 3 alvos médios no Immunefi  
- [ ] Clonar repos → `targets/active/`  
- [ ] Rodar `slither .` + anotar findings  

### Dia 9
- [ ] Analisar contratos de governança do alvo 1  
- [ ] Procurar funções sem `onlyOwner/onlyAdmin`  
- [ ] Draft report [MEDIUM] Access Control  

### Dia 10
- [ ] Analisar lógica financeira do alvo 2  
- [ ] Procurar rounding/overflow em cálculos de juros  
- [ ] Draft report [HIGH] Precision Loss  

### Dia 11
- [ ] Analisar liquidez/oracle do alvo 3  
- [ ] Simular manipulação de preço em Hardhat fork  
- [ ] Draft report [HIGH] Oracle Manipulation  

### Dia 12
- [ ] Revisar reports escritos (clareza + impacto)  
- [ ] Rodar PoCs com logs reais (`forge test -vvvv`)  
- [ ] Submeter report 1  

### Dia 13
- [ ] Refinar report 2  
- [ ] Submeter report 2  
- [ ] Estudar reports rejeitados (se houver)  

### Dia 14
- [ ] Rodar `smart-monitor.sh` em MakerDAO/Uniswap  
- [ ] Auditar commits recentes  
- [ ] Ler artigos/papers DeFi  

---

## ⚡ Semana 3 – Acelerando

**Meta:** submeter 3+ reports high severity ($15k+).  

### Dia 15
- [ ] Foco total no protocolo grande #1 (Curve)  
- [ ] Auditar `StableSwap.sol` linha por linha  
- [ ] Criar hipótese de bug  

### Dia 16
- [ ] Simular bug no Hardhat fork  
- [ ] PoC + logs `forge test`  
- [ ] Draft report crítico  

### Dia 17
- [ ] Revisar documentação do protocolo grande #2 (Aave)  
- [ ] Procurar bugs de atualização/proxy sem controle  
- [ ] Draft report  

### Dia 18
- [ ] Rodar fuzzing com Echidna no protocolo grande #3  
- [ ] Analisar falsos positivos  
- [ ] Documentar achados  

### Dia 19
- [ ] Consolidar findings  
- [ ] Escrever reports 3 e 4  
- [ ] Submeter report 3  

### Dia 20
- [ ] Submeter report 4  
- [ ] Preparar PoC visual (logs + gas report)  
- [ ] Networking no Discord/CTF  

### Dia 21
- [ ] Rodar `monitor-bounties.sh` (novos programas)  
- [ ] Pegar bounty recém-aberto (first blood chance)  
- [ ] Escrever report rápido  

---

## 💎 Semana 4 – Escala para $100k

**Meta:** atingir payout high/critical (50k-100k).  

### Dia 22-23
- [ ] Revisão completa em protocolo TOP 20 (ex: Optimism, Arbitrum)  
- [ ] Ataque direcionado em **bridge/oracle**  

### Dia 24
- [ ] PoC crítico em fork mainnet  
- [ ] Validação em várias chains (ETH, Arbitrum, Optimism)  

### Dia 25
- [ ] Report crítico estruturado (CVSS 10.0 + logs + impacto TVL)  
- [ ] Submissão  

### Dia 26
- [ ] Monitoramento contínuo → novo target (Uniswap V3)  
- [ ] PoC em `flashSwap()` ou manipulação de fee tier  

### Dia 27
- [ ] Escrever + submeter report high/critical #2  

### Dia 28
- [ ] Ajustes conforme feedback Immunefi  
- [ ] Negociar **payout máximo** baseado no TVL/impacto  

### Dia 29
- [ ] Consolidar ganhos ($100k target)  
- [ ] Documentar tudo no repo privado  

### Dia 30
- [ ] Preparar **plano de 90 dias** (novo ciclo de hunting)  
- [ ] Networking → chamar hunters no Discord Immunefi para collab  

---

# ✅ Resumo de Metas Semanais

- **Semana 1:** Setup completo + 20 reports críticos estudados  
- **Semana 2:** 2 reports submetidos (medium/high)  
- **Semana 3:** +3 reports (incluindo 1 crítico)  
- **Semana 4:** 1-2 críticos aceitos = $100k+  
```

---

Quer que eu também monte esse `.md` em **formato Kanban estilo Trello** (com colunas “A Fazer / Em Progresso / Concluído”) para você arrastar as tasks no Notion?
