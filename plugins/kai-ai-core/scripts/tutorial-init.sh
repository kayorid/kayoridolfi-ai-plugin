#!/usr/bin/env bash
# kai-ai-core / scripts / tutorial-init.sh
# Cria sandbox com repositório fictício para tutorial guiado.

set -euo pipefail

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(dirname "$(dirname "$(realpath "$0")")")}"
# shellcheck disable=SC1091
source "$PLUGIN_ROOT/lib/colors.sh" 2>/dev/null || true
kai_load_palette 2>/dev/null || true

SANDBOX="${HOME}/.kai/tutorial-sandbox"

if [[ -d "$SANDBOX" ]]; then
  printf "${C_WARN:-}⚠${C_RESET:-} Sandbox já existe em %s\n" "$SANDBOX"
  printf "Para recomeçar, remova com: rm -rf %s\n" "$SANDBOX"
  exit 1
fi

mkdir -p "$SANDBOX"
cd "$SANDBOX"

git init -q
git config user.email "tutorial@kai.local"
git config user.name "Kayoridolfi AI Tutorial"

# Cria repositório fictício "DemoTrading"
mkdir -p src/trading tests docs

cat > README.md <<'EOF'
# DemoTrading

Repositório fictício para tutorial do Kayoridolfi AI. NÃO É CÓDIGO REAL DE PRODUÇÃO.

Imagine que você é dev neste squad. Vamos passar pelo ciclo SDD completo
construindo a feature "adicionar par BTC/USDC à listagem".
EOF

cat > package.json <<'EOF'
{
  "name": "kai-demo-app",
  "version": "0.0.1",
  "description": "Sandbox tutorial Kayoridolfi AI",
  "scripts": {
    "test": "echo 'Sem testes ainda — vamos criar via /kai-spec'"
  }
}
EOF

mkdir -p src/trading
cat > src/trading/pairs.js <<'EOF'
// Pares ativos do app (estado inicial)
export const ACTIVE_PAIRS = [
  { base: 'BTC', quote: 'BRL', minOrder: 0.0001 },
  { base: 'ETH', quote: 'BRL', minOrder: 0.001 },
];
EOF

cat > .gitignore <<'EOF'
node_modules/
.env
.DS_Store
EOF

git add -A
git commit -q -m "chore: estado inicial do sandbox tutorial"

printf "\n${C_PRIMARY:-}${C_BOLD:-}✓ Sandbox criado em ${SANDBOX}${C_RESET:-}\n\n"
printf "${C_INFO:-}Próximos passos:${C_RESET:-}\n"
printf "  1. ${C_BOLD:-}cd %s${C_RESET:-}\n" "$SANDBOX"
printf "  2. Abra o Claude Code aqui\n"
printf "  3. Siga o roteiro: ${C_BOLD:-}cat ${PLUGIN_ROOT}/scripts/tutorial-roteiro.md${C_RESET:-}\n\n"
printf "${C_DIM:-}Tempo estimado: 45-60 min para o ciclo SDD completo${C_RESET:-}\n\n"
