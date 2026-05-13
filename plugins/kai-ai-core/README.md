# kai-ai-core

Plugin obrigatório do Kayoridolfi AI Plugin. Carrega constitution, hooks bloqueantes de segurança e compliance, allowlist de MCPs e comandos base.

## O que entrega

- **Constitution** carregada via skill `kai-constitution` em todo contexto.
- **Hooks bloqueantes** (categorias SEGURANÇA e COMPLIANCE):
  - `pre-commit-secret-scan` — bloqueia commit com segredos detectados.
  - `pre-tool-mcp-allowlist` — bloqueia uso de MCP fora da allowlist.
  - `pre-bash-destructive-confirm` — exige confirmação para comandos destrutivos.
  - `post-commit-audit-log` — anexa metadado de auditoria via git notes.
- **Comandos base:**
  - `/kai-help` — visão geral do SDK e plugins ativos.
  - `/kai-status` — diagnóstico de instalação e conformidade.
  - `/kai-approve <fase>` — registra aprovação humana de fase SDD.
  - `/kai-exception` — abre exceção formal a regra bloqueante.

## Instalação

Via marketplace. Ver `docs/playbooks/install-by-role.md` no repo raiz.

## Configuração

- `config/constitution.md` — princípios não-negociáveis.
- `config/mcp-allowlist.json` — MCPs aprovados.

Ambos versionados no SDK; mudanças via PR ao `kayoridolfi-ai-plugin` com revisão do maintainers.
