# Migration Guide — Kayoridolfi AI

Guia de migração entre versões do Kayoridolfi AI. Atualize na ordem recomendada (não pule majors).

---

## v2.0 → v2.1

**Tipo:** minor — sem breaking changes.

### O que muda

- **Plugin novo `kai-intel@2.1.0`** — knowledge graph cross-squad, busca BM25, drift detection. Opt-in.
- **`/kai-telemetry`** em `kai-ai-core` — telemetria 100% local, opt-in explícito. Padrão desligado.
- **`kai-cost` hook `Stop`/`SessionEnd` (`cost-finalize.sh`)** — agrega usage real do transcript JSONL. Captura passa a ser robusta (resolve limitação documentada da v1.x). Hook `cost-capture` (PostToolUse) **continua existindo** — agora complementar.
- Bump versão sincronizado em todos os 10 plugins.

### Como migrar

```bash
# Atualize o repo
git pull origin main

# Reinstale plugins (apenas adiciona kai-intel)
bash scripts/install.sh github
```

Após `/plugin install kai-intel@kai`, comandos `/kai-graph-add`, `/kai-search`, `/kai-drift-check` ficam disponíveis.

### Telemetria

Padrão: **desligada**. Para habilitar:

```bash
/kai-telemetry enable
```

Para desabilitar e apagar:

```bash
/kai-telemetry disable
```

### Notas

- Não há mudança em comandos da v2.0.
- `cost-capture.sh` permanece (preserva captura intra-sessão); `cost-finalize.sh` é aditivo.
- Sem migrações de schema no `.kai/`.

---

## v0.2 → v0.3

**Tipo:** minor — sem breaking changes.

### O que muda

- **Plugin novo `kai-evals@0.3.0`** — eval framework para features que usam IA em runtime. Opt-in.
- **Comandos novos no core:** `/kai-init`, `/kai-fast`, `/kai-theme`, `/kai-search`, `/kai-new-skill`.
- **`/kai-bootstrap-rescan`** agora cria snapshot automático antes de modificar.
- **`/kai-retro-digest`** — resumo das últimas N retros.
- **CI próprio do SDK** — `.github/workflows/sdk-ci.yml` rodando smoke tests em todo PR.
- **Governança open-source** — `CONTRIBUTING.md`, `SECURITY.md`, issue templates, PR template.
- **Refresh dos docs principais** (README, MANUAL, PRESENTATION) — features novas listadas.

### Como migrar

1. **Squads que já estão na v0.2:**
   ```
   /kai-update
   ```
   - Reinicie Claude Code.
   - Rode `/kai-doctor` para validar.

2. **Squads que querem kai-evals:**
   - Adicione ao `~/.claude/settings.json`:
     ```json
     "kai-evals@kai": true
     ```
   - Reinicie.
   - Para começar: `/kai-evals-init <feature-ai>`.

3. **Squads que querem destravar `/kai-fast`:**
   - Rode `/kai-fast` — vai verificar critérios de maturidade.
   - Se passar, `/kai-fast` fica disponível.

### O que NÃO muda

- Plugin.json IDs e marketplace path.
- Layout de `.kai/`.
- Convenção de commits.
- Hooks bloqueantes existentes (apenas refinados).

---

## v0.1 → v0.2

**Tipo:** minor com correções importantes.

### O que muda

- **Identidade visual Kayoridolfi AI** — paleta laranja oficial, ASCII wordmark, statusline custom, banner SessionStart.
- **Plugin novo `kai-cost@0.2.0`** — captura de tokens.
- **Comandos novos no core:** `/kai-doctor`, `/kai-snapshot`, `/kai-dashboard`, `/kai-tutorial`, `/kai-update`, `/kai-banner`, `/kai-ascii`, `/kai-achievements`.
- **Achievement system** — 12 conquistas com notify hook em Stop.
- **Hooks de UX** — SessionStart, Stop, Notification.
- **Suite de smoke tests** em `tests/smoke/run.sh`.

### Bugs críticos corrigidos (atualize)

- **B-3:** hooks de PII e chave privada agora bloqueiam de fato (regex Perl `(?:)` corrigida para ERE).
- **B-4:** cost-capture overhead — curto-circuito antes de jq.
- **B-2:** cost-report.sh `unbound variable: FEAT`.
- **`grep` vs `ugrep`:** todas chamadas usam `grep -e --` agora.
- **`gawk asorti`:** removido em favor de iteração POSIX.

### Como migrar

1. Atualize `~/.claude/settings.json` para incluir `kai-cost@kai`.
2. Rode `/kai-update` (após v0.2 estar instalada manualmente).
3. Rode `/kai-doctor`.
4. Squad já bootstrapado não precisa rerun de `/kai-bootstrap` — `.kai/CLAUDE.md` continua válido.

---

## Convenções gerais de migração

- **Sempre** rode `/kai-snapshot create` antes de upgrade major.
- **Sempre** rode `/kai-doctor` após upgrade.
- **Major bump** (X.0.0) tem janela de migração de 30 dias documentada — squads recebem aviso prévio.
- **Comandos depreciados** mostram aviso por 1 minor antes de serem removidos.

## Versões em manutenção

| Versão | Suporte | Patches de segurança | Patches de bug |
|--------|:-------:|:--------------------:|:--------------:|
| 0.3.x  | ✓ ativo | ✓                    | ✓              |
| 0.2.x  | ✗       | ✗ — atualize          | ✗              |
| 0.1.x  | ✗       | ✗ — atualize          | ✗              |

## Em caso de problema

1. **Rollback:** `/kai-snapshot list` → `/kai-snapshot restore <name>`.
2. **Diagnóstico:** `/kai-doctor`.
3. **Suporte:** `#kai-ai-plugin` no Slack ou issue no repo.
