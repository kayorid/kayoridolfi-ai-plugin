# FAQ — Kayoridolfi AI Plugin

## Geral

**P: O que o Kayoridolfi AI Plugin *é* exatamente?**
R: Um conjunto de plugins Claude Code que padroniza o processo de desenvolvimento assistido por IA no harness. Não é um framework de runtime, não dita stack — opina sobre **como** se trabalha.

**P: Por que precisamos disso? Não dá pra cada squad usar Claude Code do jeito que quiser?**
R: Dá. Mas sem padrão: práticas inseguras se normalizam (vazamento de segredo, MCPs não-auditados), aprendizado não se consolida (cada time aprende sozinho), auditabilidade fica frágil (problema regulatório), onboarding leva muito mais tempo. O SDK garante o piso.

**P: É obrigatório?**
R: `kai-ai-core` é obrigatório para qualquer squad usando IA em código. Os demais são opt-in, mas alguns são exigidos por contexto (ex: `kai-security` se a feature toca ativo crítico).

**P: Quem mantém?**
R: maintainers, time corporativo dedicado. Mudanças vêm via PR aberto a qualquer squad — review dos maintainers + 2 Champions.

## Instalação e uso

**P: Como instalo?**
R: Veja [`docs/playbooks/install-by-role.md`](playbooks/install-by-role.md). Resumo: configurar marketplace `kai` no `~/.claude/settings.json` e ativar os plugins desejados.

**P: Sou dev solo num squad pequeno, preciso de tudo isso?**
R: Comece com `kai-ai-core` + `kai-sdd`. Adicione outros conforme necessidade.

**P: Posso usar o SDK em projeto pessoal/externos?**
R: O SDK é open-source, não disponível externamente. Para uso em projetos pessoais, use o plugin SDD original (open-source) que serviu de base.

## Stack e processo

**P: Meu squad usa stack X (Go/Rust/Swift/etc), vocês não documentaram nada para X.**
R: Por design — o SDK é stack-agnostic. `/kai-bootstrap` gera contexto específico para sua stack. Skills custom do squad cobrem padrões locais.

**P: O ciclo SDD é muito rígido. Não consigo fazer hotfix.**
R: Use `/kai-hotfix` — pula DISCUSS/SPEC, exige post-mortem em 48h.

**P: Quero fazer um spike rápido sem todo o processo.**
R: Use `/kai-spike` — branch descartável, gera só `spike.md`.

**P: Quando o ciclo SDD vai relaxar para meu squad?**
R: Após maturidade demonstrada (3+ ciclos completos sem exceções, 2+ retros com promoção de learning, Champion ativo ≥8 semanas). Aí destrava `/kai-fast` para tarefas pequenas.

## Segurança e compliance

**P: Posso desabilitar um hook que está atrapalhando?**
R: Hooks de SEGURANÇA/COMPLIANCE não. Hooks de PROCESSO/QUALIDADE sim, via `.kai/config.yaml`. Mudança fica registrada e revisada trimestralmente pelo maintainers.

**P: O SDK envia dados para fora?**
R: O SDK em si não envia nada. As ferramentas que ele orquestra (Claude Code, MCPs aprovados) seguem suas próprias políticas. MCPs externos passam por avaliação de exfiltração.

**P: Posso usar um MCP novo?**
R: Abra PR adicionando entrada em `under_review` no `mcp-allowlist.json`. maintainers avalia (segurança, custo, exfiltração) e decide.

**P: O hook bloqueou meu commit por falso-positivo. O que faço?**
R: Verifique se é falso-positivo mesmo. Se for, abra `/kai-exception` com justificativa — maintainers vai criar exceção temporária e considerar refinar o regex.

**P: Estou trabalhando com dados regulados (KYC/AML/PII). Como o SDK ajuda?**
R: Use `kai-security` ativo. `/kai-threat-model` antes do design, `/kai-compliance-check lgpd` (e outras) durante. Hooks de PII bloqueiam vazamento. Audit-log registra acessos sensíveis.

## Custos e performance

**P: Usar o SDK encarece o uso de IA?**
R: Marginalmente sim — mais leitura de constitution, hooks executando. Mas evita custo bem maior: bug em produção, retrabalho por spec mal feita, incidente de segurança. Comparativamente, um ciclo SDD bem rodado é mais barato que um ciclo ad-hoc com retrabalho.

**P: O bootstrap leva muito tempo (60-90min). Vale?**
R: Sim. Sem bootstrap, cada feature do squad gasta tempo redescobrindo contexto. Após bootstrap, contexto é carregado automaticamente.

## Aprendizado e evolução

**P: Tive uma ideia ótima para o SDK. Como contribuo?**
R: Para o squad: implemente como skill custom em `.kai/skills/`. Para o  todo: `/kai-retro-promote` abre PR ao core.

**P: Quero ver o que outros squads aprenderam.**
R: Veja `.kai/learnings/quarterly-*.md` se publicados, e participe da comunidade mensal de AI Champions.

**P: Como reportar bug no SDK?**
R: Issue no repo `kayorid/kai-ai-sdk` com label `bug`. P1 (bloqueia trabalho) → também avise no Slack.

## Suporte

**P: Onde peço ajuda?**
R: Em ordem:
1. AI Champion do seu squad.
2. `#kai-ai-plugin` Slack.
3. maintainers por email.
4. Issue no repo.

**P: Tem treinamento?**
R: Sim — onboarding de 1h ao instalar, 4h para Tech Leads, 8h para AI Champions. Calendário interno tem datas. Sandbox guiado: `/kai-tutorial init` (45-60 min auto-conduzido).

## Features v0.2 e v0.3

**P: O que é `kai-cost` e quando usar?**
R: Plugin que captura uso de tokens via hook PostToolUse. Mostra custo por fase, feature, dia, mês. Use sempre — princípio Kayoridolfi AI #9 ("custo de IA é decisão de engenharia"). Configure orçamento mensal: `/kai-cost-budget set 800`.

**P: O que é `kai-evals` e quando usar?**
R: Eval framework para features que **usam** IA em runtime (chatbot, RAG, classificador, antifraude). Garante que mudança de prompt/modelo não regride qualidade. Obrigatório para features AI antes de SHIP. Comece com `/kai-evals-init <feature>`.

**P: Como destravar `/kai-fast`?**
R: Squad maduro destrava automaticamente quando atinge: 3+ ciclos SDD completos, 0 exceções abertas, 2+ learnings promovidos ao core, 5+ achievements. Verifique progresso com `/kai-fast` (mostra critérios pendentes).

**P: Como funciona o achievement system?**
R: 12 conquistas catalogadas (de "Primeiro voo" a "Squad maduro"). Notificação celebrativa aparece automaticamente em hook Stop quando uma é desbloqueada. Veja todas em `/kai-achievements`.

**P: Posso mudar o tema visual do Kayoridolfi AI?**
R: Sim — `/kai-theme set festive` (vibrante para releases) ou `compact` (CI), `accessible` (alto contraste), `none` (sem cores). Veja com `/kai-theme show`.

**P: Como busco em specs antigas?**
R: `/kai-search <termo>` faz grep estruturado em `_active/` e `_archive/` com excerpt. Versão semântica via embeddings em v1.5.

**P: Quero criar uma skill custom para meu squad. Como?**
R: `/kai-new-skill <slug>` cria scaffolding em `.kai/skills/kai-<slug>/`. Edite `SKILL.md` com description rica + triggers em português. Para promover ao core corporativo: `/kai-retro-promote`.

**P: O dashboard mostra dados em tempo real?**
R: `/kai-dashboard` lê `.kai/audit/*` que é atualizado por hooks. Refresca a cada invocação. Sparkline de ciclos por trimestre, maturidade %, achievements N/12, próxima ação contextual.

**P: Como faço rollback se algo deu errado?**
R: `/kai-snapshot list` mostra backups; `/kai-snapshot restore <name>` reverte. Operações destrutivas (rescan) criam snapshot automático antes.

**P: O CI da GitHub Actions é distribuído ou só do SDK?**
R: Os dois. `.github/workflows/kai-ai-checks.yml` é distribuído — squads incluem em seus repos via `uses: kayorid/kayoridolfi-ai-plugin/.github/workflows/kai-ai-checks.yml@main`. `.github/workflows/sdk-ci.yml` roda no próprio repo Kayoridolfi AI (smoke tests + ShellCheck + version sync).
