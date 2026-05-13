---
description: Reanalisa o repositório e propõe deltas para .kai/CLAUDE.md (uso após refator grande ou trimestralmente)
---

# /kai-bootstrap-rescan

Reanalisa o repositório sem sobrescrever o `.kai/CLAUDE.md` existente.

## Comportamento

0. **Auto-snapshot antes de qualquer mudança:**
   ```bash
   bash "${CLAUDE_PLUGIN_ROOT}/../kai-ai-core/scripts/snapshot.sh" create pre-rescan
   ```
1. Rode `${CLAUDE_PLUGIN_ROOT}/skills/kai-bootstrap/scripts/repo-scan.sh` gerando nova `.kai/bootstrap/analysis.md`.
2. **Compare** a análise nova com a anterior (se existir).
3. Identifique deltas relevantes:
   - Linguagens/frameworks novos ou removidos.
   - Mudança de estrutura (monorepo ↔ multi-repo).
   - CI mudou.
   - Observabilidade adicionada/removida.
4. Gere `.kai/bootstrap/rescan-<DATA>.md` com diff e propostas de atualização ao `.kai/CLAUDE.md`.
5. **Não edite o `CLAUDE.md` automaticamente.** Apresente as propostas ao usuário e aguarde aprovação.
6. Após aprovação humana, aplique os deltas e crie commit:
   ```
   git commit -m "[kai-bootstrap-rescan] atualiza CLAUDE.md após mudanças no repo"
   ```

Use quando: refator grande, mudança de stack, novo serviço criado, ou trimestralmente como hygiene.

Em caso de problema, restaure: `/kai-snapshot list` e `/kai-snapshot restore <name>`.
