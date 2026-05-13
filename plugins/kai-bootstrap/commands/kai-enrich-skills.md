---
description: Identifica padrões repetidos no squad e gera scaffolding de skill custom
---

# /kai-enrich-skills

Identifique e crie skills custom do squad:

1. **Análise:**
   - Leia `.kai/bootstrap/interview.md` (especialmente respostas 4 e 8 — dores e gargalos).
   - Liste 3-5 atividades repetidas que poderiam virar skill custom.
2. **Priorize com o usuário:** apresente os candidatos e peça para escolher 1 para criar agora.
3. **Para a skill escolhida:**
   - Defina nome (`kai-<squad>-<skill>`), descrição rica para auto-trigger.
   - Identifique referências (docs externas, padrões internos) que a skill precisa carregar.
   - Identifique scripts auxiliares (se houver automação possível).
   - Gere estrutura em `.kai/skills/<nome>/`:
     ```
     SKILL.md
     references/<refs>.md
     scripts/<scripts>.sh (se aplicável)
     assets/templates/<templates> (se aplicável)
     ```
4. Adicione a skill ao `.kai/skills/README.md` com índice.
5. Crie commit:
   ```
   git commit -m "[kai-enrich-skills] cria skill <nome>"
   ```

**Boas práticas para skills custom:**
- Description rica com triggers de uso (em português).
- Referências separadas do SKILL.md principal (carregamento sob demanda).
- Scripts em bash/python pequenos e idempotentes.
- Templates como `.tpl` para distinguir de arquivos finais.
