# 🔧 SETUP DE MONITORAMENTO POSTGRESQL

Este documento explica como configurar completamente o sistema de monitoramento PostgreSQL em **qualquer máquina**.

## 📋 Pré-requisitos

- Docker e Docker Compose instalados

## 🚀 Setup Automático (Recomendado)

```bash
# Apenas um comando! 🎉
docker-compose up -d
```

**O que acontece automaticamente:**
1. ✅ Todos os containers sobem (PostgreSQL, pgBadger, Prometheus, Grafana)
2. ✅ PostgreSQL inicia com logging detalhado pré-configurado
3. ✅ pgBadger processa automaticamente os logs quando disponíveis
4. ✅ Prometheus e Grafana ficam disponíveis com healthchecks
5. ✅ Todo o monitoramento funciona imediatamente

**Verificar o status:**
```bash
# Ver status de todos os containers
docker-compose ps

# Verificar logs específicos
docker logs postgres
docker logs pgbadger
docker logs prometheus
docker logs grafana
```

## 🛠️ Setup Manual (apenas se necessário)

### 1. Configurar PostgreSQL
```sql
docker exec postgres psql -U postgres -c "
    ALTER SYSTEM SET log_min_duration_statement = 0;
    ALTER SYSTEM SET log_connections = on;
    ALTER SYSTEM SET log_disconnections = on;
    SELECT pg_reload_conf();
"
```

### 2. Processar logs do pgBadger
```bash
docker exec pgbadger /usr/bin/pgbadger \
    -v -f stderr --sample 3 \
    -o /var/lib/pgbadger/outdir/postgresql.html \
    /var/lib/pgbadger/log/postgresql-postgres.log
```

## 📊 Acessar Ferramentas

| Ferramenta | URL | Credenciais |
|------------|-----|-------------|
| **Grafana** | http://localhost:4000 | admin/senha |
| **Prometheus** | http://localhost:9090 | - |
| **pgBadger** | http://localhost:5000 | - |
| **PostgreSQL Exporter** | http://localhost:9187/metrics | - |

## 🧪 Testar Monitoramento

Execute queries pesadas para ver o impacto nos dashboards:

```sql
-- Conectar ao PostgreSQL
docker exec -it postgres psql -U postgres -d steam_games

-- Query pesada de teste
SELECT 
    g1.name,
    g2.name AS other_game,
    g1.current_price,
    g2.current_price,
    (SELECT COUNT(*) FROM games WHERE name LIKE '%' || SUBSTRING(g1.name, 1, 2) || '%') AS count1,
    (SELECT COUNT(*) FROM games WHERE current_price = g1.current_price) AS count2,
    MD5(g1.name || g2.name) AS hash_value
FROM games g1
CROSS JOIN games g2
WHERE g1.app_id != g2.app_id
    AND g1.name LIKE '%a%'
    AND g2.name LIKE '%e%'
    AND g1.current_price > 0
    AND g2.current_price > 0
ORDER BY RANDOM()
LIMIT 50;
```

## 📈 Métricas Importantes

### Grafana - Queries PromQL úteis:
```promql
# Taxa de dados processados
rate(pg_stat_database_tup_returned{datname="steam_games"}[5m])

# Conexões ativas
pg_stat_activity_count{datname="steam_games",state="active"}

# Uso de CPU (estimado)
rate(pg_stat_database_tup_returned{datname="steam_games"}[5m]) * 100
```

### pgBadger - O que observar:
- **Slowest individual queries**: Queries mais lentas
- **Time consuming queries**: Queries que consomem mais tempo total
- **Top Queries**: Histograma de tempos de execução

## 🔧 Configurações Aplicadas Automaticamente

O sistema configura automaticamente:

| Configuração | Valor | Função |
|-------------|-------|--------|
| `log_min_duration_statement` | `0` | Loga duração de todas as queries |
| `log_connections` | `on` | Loga todas as conexões |
| `log_disconnections` | `on` | Loga todas as desconexões |
| `log_statement` | `all` | Loga todas as declarações SQL |
| `log_line_prefix` | `'%t [%p]: [%l-1] '` | Formato compatível com pgBadger |
| `shared_preload_libraries` | `pg_stat_statements` | Habilita estatísticas estendidas |

## 🆘 Solução de Problemas

### pgBadger mostra "NO DATASET":
```bash
# Reprocessar logs manualmente
docker exec pgbadger /usr/bin/pgbadger \
    -v -f stderr --sample 3 \
    -o /var/lib/pgbadger/outdir/postgresql.html \
    /var/lib/pgbadger/log/postgresql-postgres.log
```

### Prometheus não mostra métricas:
```bash
# Verificar se o PostgreSQL Exporter está funcionando
curl http://localhost:9187/metrics
```

### Grafana mostra "No data":
- Verifique se há atividade no PostgreSQL
- Confirme o intervalo de tempo selecionado (últimos 15 minutos)
- Execute queries de teste para gerar atividade

## ✅ Verificação Final

Após o setup, você deve ver:

1. **Grafana**: Dashboards com métricas em tempo real
2. **Prometheus**: Targets "up" e métricas sendo coletadas
3. **pgBadger**: Relatórios com queries e durações reais (não 0ms)

