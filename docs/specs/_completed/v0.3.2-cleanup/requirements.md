# v0.3.2 — Cleanup técnico + E2E

## WHY

Antes de empilhar features (v0.5, v1.0), fechar dívidas técnicas reais identificadas no REVIEW.md (M-1, M-3, M-7, M-8, M-9, M-10) e elevar confiança nas mudanças com uma suite de teste E2E que simule o ciclo de uso real do SDK.

## Stakeholders

- **maintainers** — donos do plugin
- **Squads piloto** — consumidores; precisam de release confiável antes de v0.5
- **equipe de Security** — auditores; M-10 (ReDoS) e M-1 (consolidação de hooks) reduzem superfície

## User stories

- **US-1** Como mantenedor do SDK, quero hooks PreToolUse consolidados em um único script para reduzir overhead em 3x em cada Write/Edit.
- **US-2** Como squad piloto, quero o banner SessionStart sem ANSI colors no `additionalContext` para economizar tokens.
- **US-3** Como mantenedor, quero suite E2E que valide o fluxo `kai-init → kai-bootstrap → kai-spec → kai-implement → kai-retro` num repo dummy para detectar regressão em PRs.
- **US-4** Como security , quero `mcp-allowlist.sh` logar warn explícito quando allowlist está corrompida.
- **US-5** Como auditor, quero `private-key-scan.sh` resistente a ReDoS (input cap + regex ancorada).
- **US-6** Como squad piloto, quero achievement checker cacheado em `.kai/achievements.json` para `/kai-achievements` rodar em <100ms em repos com 50k+ commits.

## Critérios de aceitação (EARS)

- **CA-1** Quando o usuário invocar Write ou Edit, o sistema **deve** executar um único `pre-write-guard.sh` que cobre regras de kai-ai-core + kai-security, com tempo de hook total < 200ms em payload de 10KB.
- **CA-2** Onde o banner SessionStart for emitido como `additionalContext`, o sistema **não deve** incluir caracteres ANSI (`\033[` ou `\e[`); apenas texto cru com no máximo 300 tokens de payload.
- **CA-3** Quando `tests/e2e/run.sh` for executado num diretório temporário limpo, o sistema **deve** completar o ciclo `init→bootstrap→spec→implement→retro` em <60s e retornar exit 0.
- **CA-4** Se o arquivo de allowlist MCP for sintaticamente inválido (JSON corrompido), o sistema **deve** emitir em stderr `[kai-ai-core] WARN — allowlist file corrupto em <path>` e manter comportamento failsafe.
- **CA-5** Quando `private-key-scan.sh` receber input >100KB, o sistema **deve** truncar antes do grep e logar `[kai-security] INFO — input truncated`.
- **CA-6** Enquanto não houver mudança em commits, o sistema **deve** servir resultado cacheado de achievements (TTL 5min); se cache hit, tempo total <100ms.
- **CA-7** Quando o usuário rodar `bash tests/smoke/run.sh`, o sistema **deve** reportar 95+ verificações OK (90 existentes + novos testes dos itens acima).

## Fora de escopo

- Mudanças em features de v0.5 (leaderboard, retro-quarterly) — outra spec.
- Refator amplo da arquitetura de hooks (continua bash + jq).
- Captura de cost real via Stop hook lendo transcript (movido para v1.0).

## Boundaries

- ✅ **Always:** preservar backward-compat dos comandos `/kai-*` existentes; bumpar versão de todos os 9 plugins + marketplace.json juntos.
- ⚠️ **Ask first:** qualquer mudança que altere comportamento de hook bloqueante (rejeição de Write/Edit).
- 🚫 **Never:** quebrar a suite smoke ou completeness; pular hooks com `--no-verify`; usar `git push --force`.

## Clarifications

- **Q:** "Consolidação de hooks" remove `kai-security` ou só o duplicado em `kai-ai-core`?
  - **R:** O secret-scan em `kai-ai-core` cobre apenas chave privada (regra duplicada). `kai-security` permanece e ganha `pre-write-guard.sh` único que agrupa pii-scan + private-key-scan + secret-scan. `kai-ai-core` deixa de fazer Write/Edit scan; mantém apenas pré-commit/pré-push.
- **Q:** E2E precisa de cluster real, Docker, repo  real?
  - **R:** Não. Roda em `mktemp -d`, simula squad bootstrap via env vars, mocka Claude Code invocando scripts diretamente. Objetivo é validar plumbing, não LLM behavior.
- **Q:** Cache de achievements é por-repo ou global?
  - **R:** Por-repo, em `.kai/achievements.json` (já no `.gitignore`).
