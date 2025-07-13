#!/bin/bash
# Script para configurar monitoramento automaticamente em qualquer máquina

echo "=== SETUP DE MONITORAMENTO COMPLETO ==="
echo "Este script configura automaticamente todas as ferramentas de monitoramento"

# Aguardar PostgreSQL estar pronto
echo "Aguardando PostgreSQL estar disponível..."
until docker exec postgres psql -U postgres -c "SELECT 1;" > /dev/null 2>&1; do
    echo "  - PostgreSQL ainda não está pronto, aguardando..."
    sleep 5
done
echo "PostgreSQL está pronto!"

# Confirmar configurações (caso não tenham sido aplicadas via entrypoint)
echo "Confirmando configurações do PostgreSQL..."
docker exec postgres psql -U postgres -c "
    ALTER SYSTEM SET log_min_duration_statement = 0;
    ALTER SYSTEM SET log_connections = on;
    ALTER SYSTEM SET log_disconnections = on;
    SELECT pg_reload_conf();
" > /dev/null 2>&1

echo "Configurações do PostgreSQL confirmadas!"

# Aguardar pgBadger estar pronto
echo "Aguardando pgBadger estar disponível..."
until docker exec pgbadger ls /var/lib/pgbadger/log/ > /dev/null 2>&1; do
    echo "  - pgBadger ainda não está pronto, aguardando..."
    sleep 5
done

# Forçar processamento inicial do pgBadger
echo "Processando logs iniciais do pgBadger..."
docker exec pgbadger /usr/bin/pgbadger \
    -v -f stderr --sample 3 \
    -o /var/lib/pgbadger/outdir/postgresql.html \
    /var/lib/pgbadger/log/postgresql-postgres.log > /dev/null 2>&1

echo "pgBadger configurado!"

# Verificar Prometheus
echo "Verificando Prometheus..."
until curl -s http://localhost:9090/api/v1/query?query=up > /dev/null 2>&1; do
    echo "  - Prometheus ainda não está pronto, aguardando..."
    sleep 5
done
echo "Prometheus está funcionando!"

# Verificar Grafana
echo "Verificando Grafana..."
until curl -s http://localhost:4000 > /dev/null 2>&1; do
    echo "  - Grafana ainda não está pronto, aguardando..."
    sleep 5
done
echo "✅ Grafana está funcionando!"

echo ""
echo "🎉 MONITORAMENTO CONFIGURADO COM SUCESSO!"
echo ""
echo "📊 Acesse as ferramentas:"
echo "   - Grafana:     http://localhost:4000 (admin/admin)"
echo "   - Prometheus:  http://localhost:9090"
echo "   - pgBadger:    http://localhost:5000"
echo ""
echo "🔧 Para testar o monitoramento, execute:"
echo "   docker exec -it postgres psql -U postgres -d steam_games"
echo "   e rode queries pesadas para ver o impacto nos dashboards!"
