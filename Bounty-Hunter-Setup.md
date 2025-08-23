# Web3 Bug Bounty Hunter Setup – Scripts Prontos

## 📁 Estrutura de Diretórios

```bash
BUGBASE="$HOME/Library/Mobile Documents/com~apple~CloudDocs/BugBounty"

mkdir -p "$BUGBASE"/{targets,reports,pocs,tools,scripts,templates,research,earnings,logs}
mkdir -p "$BUGBASE"/targets/{active,archive,monitoring}
mkdir -p "$BUGBASE"/reports/{submitted,accepted,rejected,draft}
mkdir -p "$BUGBASE"/pocs/{foundry,hardhat,custom}
mkdir -p "$BUGBASE"/research/{vulns,techniques,writeups}
