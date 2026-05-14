# kai-intel — Inteligência Operacional

Plugin v2.1 do Kayoridolfi AI. Três capacidades complementares para **conhecer o que o squad já decidiu, achar o que ele já escreveu e detectar quando o código divergiu do que foi planejado**.

## Comandos

| Comando | Descrição |
|---------|-----------|
| `/kai-graph-add` | Adiciona um nó (decisão/learning/spec/incidente) ao grafo `.kai/intel/graph.json` |
| `/kai-graph-query` | Consulta nós por tipo, tag, squad ou texto |
| `/kai-graph-export` | Exporta grafo em DOT (Graphviz) ou Mermaid |
| `/kai-search` | Busca lexical com ranking BM25 sobre `.kai/`, `docs/specs/`, decisões e retros |
| `/kai-drift-check` | Compara spec/plan ↔ código real e sinaliza divergências |

## Estrutura no `.kai/`

```
.kai/
├── intel/
│   ├── graph.json          ← nós e arestas (decisão, learning, spec, incident)
│   ├── search-index.json   ← índice BM25 (gerado por kai-search --index)
│   └── drift/              ← relatórios de drift por feature
└── ...
```

## Filosofia

- **Local-first.** Tudo fica em `.kai/intel/` no repo. Sem cloud, sem telemetria externa.
- **Plain JSON.** Editável à mão. Versionável no git se o squad quiser.
- **Sem dependências exóticas.** Bash + jq + awk. Search BM25 puro shell.
- **Upgrade path para embeddings.** A interface `/kai-search` é estável; a v2.5+ pode trocar BM25 por embeddings sem quebrar callers.

## Início rápido

```bash
# Adicionar uma decisão
/kai-graph-add decision "Adotar gRPC entre payments e ledger" --tags arch,api --squad payments

# Buscar
/kai-search "retry policy"

# Drift check da spec ativa
/kai-drift-check
```
