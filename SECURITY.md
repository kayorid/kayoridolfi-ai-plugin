# Política de Segurança — Kayoridolfi AI

## Reportando uma vulnerabilidade

O Kayoridolfi AI lida com hooks bloqueantes em ambiente de desenvolvimento de uma projeto em ambiente regulado. Vulnerabilidades têm impacto potencial sério (vazamento de segredos, bypass de proteções, falha em auditoria regulatória).

### Como reportar

**Não abra issue público.** Use um destes canais:

1. **GitHub Security Advisory (preferencial):** [github.com/kayorid/kayoridolfi-ai-plugin/security/advisories/new](https://github.com/kayorid/kayoridolfi-ai-plugin/security/advisories/new)
2. **Email:** `kayocdi@gmail.com` (assunto começando com `[security]`)

### O que incluir

- Descrição clara da vulnerabilidade.
- Passos para reproduzir.
- Impacto potencial (qual proteção é bypassada, qual dado pode vazar).
- Versão do Kayoridolfi AI e ambiente (OS, shell, jq version).
- Sugestão de fix se tiver.

### O que esperar

- **Confirmação** em até 48h úteis.
- **Análise inicial** em até 5 dias úteis.
- **Correção** prazos por severidade:
  - Crítica (RCE, bypass total de hook bloqueante): patch em 7 dias.
  - Alta (bypass de regra específica, leak parcial): 14 dias.
  - Média/baixa: próxima minor.
- **CVE/advisory** publicado após correção, com crédito ao reportador (se desejar).

## Escopo

### Em escopo
- Bypass de hooks bloqueantes (secret-scan, pii-scan, private-key-scan, mcp-allowlist, destructive-confirm).
- Vazamento de dados via audit logs.
- Race conditions que corrompam audit trail.
- Injeção via payload de hook.
- Privilege escalation via comandos `/kai-*`.
- Vulnerabilidades em scripts shell (command injection, path traversal).

### Fora de escopo
- Vulnerabilidades no Claude Code (reporte para Anthropic).
- Vulnerabilidades em MCPs externos (reporte para o publisher).
- Vulnerabilidades em dependências de sistema (jq, bash, git) — exceto se uso pelo Kayoridolfi AI cria nova superfície.
- DOS via consumo de tokens (não é nosso threat model).
- Ataques físicos ao desenvolvedor.

## Princípios

- **Não temos bug bounty financeiro** (este é um projeto open-source).
- **Crédito público** ao pesquisador é dado (se desejar).
- **Transparência pós-fix** — advisory público com lições aprendidas.
- **Sem represália** — pesquisadores responsáveis nunca terão problema legal por reportar dentro deste processo.

## Versões suportadas

Apenas versão major mais recente recebe patches de segurança.

| Versão | Suporte |
|--------|:-------:|
| 2.x    | ✓ ativa |
| 1.x    | ✗ — atualize |
| 0.x    | ✗ — atualize |

## Hardening recomendado para usuários

1. Rode `/kai-doctor` periodicamente.
2. Mantenha SDK atualizado: `/kai-update`.
3. Não desabilite hooks de SEGURANÇA via edição manual de `.kai/config.yaml`.
4. Se hook bloquear trabalho legítimo, abra `/kai-exception` (registrado em audit-trail) — não force bypass.
5. Revise `.kai/audit/security-events.log` semanalmente.
6. Use `git push --force-with-lease` em vez de `--force`.
