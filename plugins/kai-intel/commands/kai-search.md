---
description: Busca lexical com ranking BM25 sobre .kai/, decisões, specs e retros
argument-hint: <query> [--limit N] [--reindex] [--json]
---

# /kai-search

Busca rankeada (BM25) sobre todo o conteúdo textual do projeto Kayoridolfi.

## Uso

```bash
/kai-search "retry policy"
/kai-search "rate limit" --limit 5
/kai-search --reindex            # força reconstrução do índice
/kai-search "kafka" --json       # output JSON para tooling
```

## Execução

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/search.sh" "$@"
```

## Cobertura

Índice é construído a partir de:
- `.kai/intel/graph.json` (nós do knowledge graph)
- `docs/specs/_active/**/*.md` e `_completed/**/*.md`
- `docs/playbooks/**/*.md`
- `docs/runbooks/**/*.md` (se existir)
- `.kai/audit/*.log` (somente quando explícito com `--audit`)

Índice persistido em `.kai/intel/search-index.json`. Auto-rebuild se mais antigo que 24h.

## Implementação

BM25 puro shell (k1=1.5, b=0.75). Stop-word PT-BR mínima. Tokenização por whitespace + lowercase. Roadmap v2.5: trocar por embeddings preservando a interface CLI.
