#!/usr/bin/env bash
# Kayoridolfi AI · Completeness check
# Loop de garantia: lista TUDO que deve existir e valida.
# Usado iterativamente até zero falhas.

set -uo pipefail

ROOT="$(cd "$(dirname "$(realpath "$0")")"/.. && pwd)"
cd "$ROOT"

GOLD=$'\033[38;2;232;85;12m'
GREEN=$'\033[38;5;82m'
RED=$'\033[38;5;196m'
YELLOW=$'\033[38;5;220m'
DIM=$'\033[2m'
BOLD=$'\033[1m'
RESET=$'\033[0m'

PASS=0
FAIL=0

t_pass() { printf "  ${GREEN}✓${RESET} %s\n" "$1"; PASS=$((PASS+1)); }
t_fail() { printf "  ${RED}✗${RESET} %s\n" "$1"; FAIL=$((FAIL+1)); }
section() { printf "\n${GOLD}${BOLD}▸ %s${RESET}\n" "$1"; }

printf "\n${GOLD}${BOLD}Kayoridolfi AI · Completeness Check${RESET}\n"
printf "${DIM}Garantia: tudo que foi prometido está entregue${RESET}\n"

# ============================================================
section "Plugins esperados (10)"
# ============================================================
EXPECTED_PLUGINS=(kai-ai-core kai-bootstrap kai-sdd kai-review kai-observability kai-security kai-retro kai-cost kai-evals kai-intel)
for p in "${EXPECTED_PLUGINS[@]}"; do
  if [[ -d "plugins/$p" && -f "plugins/$p/.claude-plugin/plugin.json" ]]; then
    t_pass "plugin: $p"
  else
    t_fail "plugin AUSENTE: $p"
  fi
done

# ============================================================
section "Comandos esperados v0.3.1 (lista canônica)"
# ============================================================
EXPECTED_CMDS=(
  # kai-ai-core
  "kai-ai-core/kai-help" "kai-ai-core/kai-status" "kai-ai-core/kai-approve" "kai-ai-core/kai-exception"
  "kai-ai-core/kai-init" "kai-ai-core/kai-doctor" "kai-ai-core/kai-snapshot" "kai-ai-core/kai-dashboard"
  "kai-ai-core/kai-tutorial" "kai-ai-core/kai-update" "kai-ai-core/kai-banner" "kai-ai-core/kai-ascii"
  "kai-ai-core/kai-achievements" "kai-ai-core/kai-fast" "kai-ai-core/kai-theme" "kai-ai-core/kai-search"
  "kai-ai-core/kai-new-skill" "kai-ai-core/kai-version" "kai-ai-core/kai-list-plugins"
  "kai-ai-core/kai-telemetry"
  # kai-bootstrap
  "kai-bootstrap/kai-bootstrap" "kai-bootstrap/kai-bootstrap-rescan"
  "kai-bootstrap/kai-enrich-domain" "kai-bootstrap/kai-enrich-runbooks" "kai-bootstrap/kai-enrich-skills"
  # kai-sdd
  "kai-sdd/kai-spec" "kai-sdd/kai-spec-discuss" "kai-sdd/kai-spec-requirements"
  "kai-sdd/kai-spec-design" "kai-sdd/kai-spec-plan" "kai-sdd/kai-spec-execute"
  "kai-sdd/kai-spec-verify" "kai-sdd/kai-spec-retro" "kai-sdd/kai-hotfix" "kai-sdd/kai-spike"
  # kai-review
  "kai-review/kai-review-pr" "kai-review/kai-review-security"
  "kai-review/kai-review-spec" "kai-review/kai-review-fix"
  # kai-observability
  "kai-observability/kai-observability-design" "kai-observability/kai-observability-review"
  "kai-observability/kai-runbook-from-incident"
  # kai-security
  "kai-security/kai-threat-model" "kai-security/kai-security-checklist"
  "kai-security/kai-compliance-check" "kai-security/kai-secret-rotate"
  # kai-retro
  "kai-retro/kai-retro" "kai-retro/kai-retro-promote" "kai-retro/kai-retro-extract-skill"
  "kai-retro/kai-retro-quarterly" "kai-retro/kai-retro-digest"
  "kai-retro/kai-leaderboard" "kai-retro/kai-newsletter"
  "kai-retro/kai-adoption-report"
  "kai-sdd/kai-spec-from-ticket"
  # kai-cost
  "kai-cost/kai-cost" "kai-cost/kai-cost-feature" "kai-cost/kai-cost-budget" "kai-cost/kai-cost-alert"
  # kai-evals
  "kai-evals/kai-evals-init" "kai-evals/kai-evals-run" "kai-evals/kai-evals-compare" "kai-evals/kai-evals-ci"
  # kai-intel (v2.1)
  "kai-intel/kai-graph-add" "kai-intel/kai-graph-query" "kai-intel/kai-graph-export"
  "kai-intel/kai-search" "kai-intel/kai-drift-check"
)
for cmd in "${EXPECTED_CMDS[@]}"; do
  PLUGIN="${cmd%%/*}"
  CMDNAME="${cmd##*/}"
  if [[ -f "plugins/$PLUGIN/commands/$CMDNAME.md" ]]; then
    t_pass "$cmd.md"
  else
    t_fail "comando AUSENTE: $cmd.md"
  fi
done

# ============================================================
section "Skills esperadas (15)"
# ============================================================
EXPECTED_SKILLS=(
  "kai-ai-core/kai-constitution"
  "kai-bootstrap/kai-bootstrap"
  "kai-sdd/kai-sdd"
  "kai-review/kai-code-reviewer" "kai-review/kai-security-reviewer" "kai-review/kai-spec-reviewer"
  "kai-observability/kai-observability-designer" "kai-observability/kai-observability-reviewer"
  "kai-security/kai-threat-modeler" "kai-security/kai-compliance-advisor" "kai-security/kai-crypto-advisor"
  "kai-retro/kai-retro-facilitator" "kai-retro/kai-learning-extractor"
  "kai-evals/kai-evals"
  "kai-intel/kai-intel"
)
for skill in "${EXPECTED_SKILLS[@]}"; do
  PLUGIN="${skill%%/*}"
  SKILL_NAME="${skill##*/}"
  if [[ -f "plugins/$PLUGIN/skills/$SKILL_NAME/SKILL.md" ]]; then
    t_pass "skill: $skill"
  else
    t_fail "skill AUSENTE: plugins/$PLUGIN/skills/$SKILL_NAME/SKILL.md"
  fi
done

# ============================================================
section "ASCII art (8)"
# ============================================================
EXPECTED_ASCII=(welcome bootstrap-done spec-start ship hotfix retro mature-squad kai-wordmark)
for art in "${EXPECTED_ASCII[@]}"; do
  if [[ -f "plugins/kai-ai-core/assets/ascii/${art}.txt" ]]; then
    t_pass "ascii: ${art}.txt"
  else
    t_fail "ascii AUSENTE: ${art}.txt"
  fi
done

# ============================================================
section "Hooks scripts (>=11)"
# ============================================================
EXPECTED_HOOKS=(
  "kai-ai-core/secret-scan.sh"
  "kai-ai-core/destructive-confirm.sh"
  "kai-ai-core/mcp-allowlist.sh"
  "kai-ai-core/audit-log.sh"
  "kai-ai-core/session-start-banner.sh"
  "kai-ai-core/stop-farewell.sh"
  "kai-ai-core/notify.sh"
  "kai-ai-core/statusline.sh"
  "kai-security/pii-scan.sh"
  "kai-security/private-key-scan.sh"
  "kai-cost/cost-capture.sh"
  "kai-cost/cost-finalize.sh"
)
for hook in "${EXPECTED_HOOKS[@]}"; do
  PLUGIN="${hook%%/*}"
  SCRIPT="${hook##*/}"
  if [[ -f "plugins/$PLUGIN/hooks/scripts/$SCRIPT" && -x "plugins/$PLUGIN/hooks/scripts/$SCRIPT" ]]; then
    t_pass "hook: $hook"
  else
    t_fail "hook AUSENTE/não-executável: $hook"
  fi
done

# ============================================================
section "Scripts utilitários (>=15)"
# ============================================================
EXPECTED_SCRIPTS=(
  "kai-ai-core/scripts/doctor.sh"
  "kai-ai-core/scripts/snapshot.sh"
  "kai-ai-core/scripts/dashboard.sh"
  "kai-ai-core/scripts/update.sh"
  "kai-ai-core/scripts/tutorial-init.sh"
  "kai-ai-core/scripts/init-wizard.sh"
  "kai-ai-core/scripts/fast-mode.sh"
  "kai-ai-core/scripts/search-specs.sh"
  "kai-ai-core/scripts/new-skill.sh"
  "kai-ai-core/scripts/version.sh"
  "kai-ai-core/scripts/telemetry.sh"
  "kai-ai-core/achievements/checker.sh"
  "kai-ai-core/achievements/notify.sh"
  "kai-ai-core/lib/colors.sh"
  "kai-ai-core/lib/spinner.sh"
  "kai-ai-core/lib/ascii.sh"
  "kai-bootstrap/skills/kai-bootstrap/scripts/repo-scan.sh"
  "kai-cost/scripts/cost-report.sh"
  "kai-evals/scripts/init-eval.sh"
  "kai-evals/scripts/run-eval.sh"
  "kai-evals/scripts/ci-eval.sh"
  "kai-evals/scripts/compare-eval.sh"
  "kai-retro/scripts/retro-digest.sh"
  "kai-retro/scripts/leaderboard.sh"
  "kai-retro/scripts/newsletter.sh"
  "kai-retro/scripts/adoption-report.sh"
  "kai-sdd/scripts/spec-from-ticket.sh"
  "kai-intel/scripts/graph.sh"
  "kai-intel/scripts/search.sh"
  "kai-intel/scripts/drift-check.sh"
)
for script in "${EXPECTED_SCRIPTS[@]}"; do
  if [[ -f "plugins/$script" && -x "plugins/$script" ]]; then
    t_pass "script: $script"
  else
    t_fail "script AUSENTE/não-executável: plugins/$script"
  fi
done

# ============================================================
section "Documentação (10)"
# ============================================================
EXPECTED_DOCS=(
  "README.md"
  "CHANGELOG.md"
  "RELEASE-NOTES.md"
  "CONTRIBUTING.md"
  "SECURITY.md"
  "PILOT-SETUP.md"
  "HANDOFF.md"
  "docs/specs/_completed/v0.2-pre-release-review/REVIEW.md"
  "docs/plans/2026-05-10-kayoridolfi-ai-plugin-design.md"
  "docs/plans/2026-05-10-evolution-roadmap.md"
  "docs/manual/MANUAL.md"
  "docs/presentation/PRESENTATION.md"
  "docs/governance/raci.md"
  "docs/playbooks/install-by-role.md"
  "docs/MIGRATION.md"
  "docs/PLUGIN-DEVELOPMENT.md"
  "docs/faq.md"
  "docs/governance/ai-champions.md"
  "docs/playbooks/ai-lab.md"
  "docs/plugins/opt-in-guide.md"
  "docs/governance/champion-certification.md"
  "PILOT-SETUP.md"
)
for doc in "${EXPECTED_DOCS[@]}"; do
  if [[ -f "$doc" ]]; then
    t_pass "doc: $doc"
  else
    t_fail "doc AUSENTE: $doc"
  fi
done

# ============================================================
section "Integrações & CI (5)"
# ============================================================
[[ -f .github/workflows/kai-ai-checks.yml ]] && t_pass "GHA distribuído (kai-ai-checks.yml)" || t_fail "AUSENTE: kai-ai-checks.yml"
[[ -f .github/workflows/sdk-ci.yml ]] && t_pass "GHA SDK próprio (sdk-ci.yml)" || t_fail "AUSENTE: sdk-ci.yml"
[[ -f .github/PULL_REQUEST_TEMPLATE.md ]] && t_pass "PR template" || t_fail "AUSENTE: PR template"
[[ -f .github/ISSUE_TEMPLATE/bug.md ]] && t_pass "Issue template: bug" || t_fail "AUSENTE: bug.md"
[[ -f .github/ISSUE_TEMPLATE/proposal.md ]] && t_pass "Issue template: proposal" || t_fail "AUSENTE: proposal.md"
[[ -f .github/ISSUE_TEMPLATE/security.md ]] && t_pass "Issue template: security" || t_fail "AUSENTE: security.md"
[[ -f integrations/slack/manifest.yaml ]] && t_pass "Slack manifest" || t_fail "AUSENTE: Slack manifest"

# ============================================================
section "Achievements catalog (16 conquistas v0.3)"
# ============================================================
if command -v jq >/dev/null 2>&1; then
  ACH_TOTAL=$(jq -r '.achievements | length' plugins/kai-ai-core/achievements/definitions.json 2>/dev/null)
  if [[ "$ACH_TOTAL" -ge 16 ]]; then
    t_pass "achievements: $ACH_TOTAL conquistas catalogadas"
  else
    t_fail "achievements: apenas $ACH_TOTAL (esperado >=16)"
  fi
fi

# ============================================================
section "Versões sincronizadas (9 plugins == marketplace)"
# ============================================================
if command -v jq >/dev/null 2>&1; then
  ALL_OK=1
  while IFS= read -r entry; do
    NAME=$(echo "$entry" | jq -r '.name')
    MARKET_VER=$(echo "$entry" | jq -r '.version')
    PLUGIN_FILE="plugins/${NAME}/.claude-plugin/plugin.json"
    if [[ -f "$PLUGIN_FILE" ]]; then
      PLUGIN_VER=$(jq -r '.version' "$PLUGIN_FILE")
      if [[ "$MARKET_VER" == "$PLUGIN_VER" ]]; then
        t_pass "$NAME @${MARKET_VER}"
      else
        t_fail "DESSINCRONIZADO: $NAME marketplace=$MARKET_VER vs plugin.json=$PLUGIN_VER"
        ALL_OK=0
      fi
    fi
  done < <(jq -c '.plugins[]' .claude-plugin/marketplace.json)
fi

# ============================================================
# Resumo
# ============================================================

printf "\n${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
printf "  ${GREEN}✓ %d completo${RESET}    ${RED}✗ %d faltando${RESET}\n\n" "$PASS" "$FAIL"

if [[ $FAIL -gt 0 ]]; then
  printf "${RED}${BOLD}INCOMPLETO. Resolva os ✗ antes de release.${RESET}\n\n"
  exit 1
else
  printf "${GREEN}${BOLD}TUDO ENTREGUE.${RESET}\n\n"
  exit 0
fi
