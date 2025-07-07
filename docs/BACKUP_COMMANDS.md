# Comandos de Backup - PostgreSQL com pgBackRest

Este documento contém todos os comandos essenciais para gerenciar backups do PostgreSQL usando pgBackRest no ambiente Docker.

## 📋 Comandos Principais de Monitoramento

### 1. Verificar Status dos Backups Ativos
```powershell
docker exec backup pgbackrest --stanza=postgres info
```
**Descrição**: Exibe informações completas sobre todos os backups disponíveis, incluindo:
- Status geral do sistema de backup
- Lista de backups completos e incrementais
- Tamanhos dos backups
- Datas e horários de criação
- Arquivos WAL (Write-Ahead Log) disponíveis

### 2. Informações Detalhadas em JSON
```powershell
docker exec backup pgbackrest --stanza=postgres info --output=json
```
**Descrição**: Retorna as mesmas informações do comando `info`, mas em formato JSON estruturado, útil para integração com scripts ou APIs.

## 🔧 Comandos de Criação de Backup

### 3. Criar Backup Completo (Full)
```powershell
docker exec backup pgbackrest --stanza=postgres backup --type=full
```
**Descrição**: Cria um backup completo de todo o banco de dados. Este é o tipo de backup base que contém todos os dados e pode ser usado para restauração completa sem depender de outros backups.

### 4. Criar Backup Incremental
```powershell
docker exec backup pgbackrest --stanza=postgres backup --type=incr
```
**Descrição**: Cria um backup incremental que contém apenas as alterações desde o último backup (completo ou incremental). Menor em tamanho e mais rápido, mas requer backups anteriores para restauração.

### 5. Criar Backup Diferencial
```powershell
docker exec backup pgbackrest --stanza=postgres backup --type=diff
```
**Descrição**: Cria um backup diferencial que contém todas as alterações desde o último backup completo. Maior que incremental, mas menor que completo, e mais rápido para restaurar que múltiplos incrementais.

## 📊 Comandos de Monitoramento e Logs

### 6. Verificar Logs do pgBackRest
```powershell
docker exec backup ls -la /var/log/pgbackrest/
```
**Descrição**: Lista os arquivos de log do pgBackRest dentro do container, útil para diagnóstico de problemas ou verificação de atividades de backup.

### 7. Visualizar Logs em Tempo Real
```powershell
docker exec backup tail -f /var/log/pgbackrest/postgres-backup.log
```
**Descrição**: Exibe os logs de backup em tempo real (se existirem), permitindo acompanhar operações de backup conforme elas acontecem.

### 8. Verificar Configuração SSH
```powershell
docker exec backup ls -la /var/lib/postgresql/.ssh/
```
**Descrição**: Lista as configurações SSH necessárias para comunicação entre os containers de backup e PostgreSQL.

## 🗂️ Comandos de Gestão de Arquivos

### 9. Listar Backups no Sistema de Arquivos
```powershell
docker exec backup ls -la /var/lib/pgbackrest/backup/postgres/
```
**Descrição**: Mostra os diretórios físicos onde os backups estão armazenados no container.

### 10. Verificar Arquivos WAL
```powershell
docker exec backup ls -la /var/lib/pgbackrest/archive/postgres/
```
**Descrição**: Lista os arquivos WAL (Write-Ahead Log) arquivados, que são essenciais para recuperação point-in-time.

### 11. Verificar Espaço em Disco
```powershell
docker exec backup df -h /var/lib/pgbackrest/
```
**Descrição**: Mostra o uso de espaço em disco no diretório de backups, importante para monitorar capacidade de armazenamento.

## 🔄 Comandos de Restauração

### 12. Listar Pontos de Restauração Disponíveis
```powershell
docker exec backup pgbackrest --stanza=postgres info --output=json | ConvertFrom-Json | Select-Object -ExpandProperty backup
```
**Descrição**: Lista todos os pontos de backup disponíveis para restauração com detalhes sobre cada um.

### 13. Restaurar Backup Específico (Exemplo)
```powershell
docker exec backup pgbackrest --stanza=postgres restore --set=20250706-234920F
```
**Descrição**: Restaura um backup específico. **⚠️ CUIDADO**: Este comando sobrescreve os dados atuais. Use apenas em ambiente de teste ou após confirmar necessidade.

## 🧹 Comandos de Manutenção

### 14. Expirar Backups Antigos
```powershell
docker exec backup pgbackrest --stanza=postgres expire
```
**Descrição**: Remove backups antigos de acordo com a política de retenção configurada (atualmente 5 backups completos).

### 15. Verificar Integridade dos Backups
```powershell
docker exec backup pgbackrest --stanza=postgres check
```
**Descrição**: Verifica a integridade dos backups e a conectividade com o banco de dados PostgreSQL.

### 16. Verificar Configuração
```powershell
docker exec backup cat /var/lib/postgresql/pgbackrest.conf
```
**Descrição**: Exibe o arquivo de configuração do pgBackRest para verificar parâmetros e configurações.

## 🚨 Comandos de Diagnóstico

### 17. Testar Conectividade SSH
```powershell
docker exec backup ssh postgres "echo 'Conexão SSH funcionando'"
```
**Descrição**: Testa se a conexão SSH entre os containers backup e postgres está funcionando corretamente.

### 18. Verificar Status do PostgreSQL
```powershell
docker exec postgres pg_isready -U postgres -d steam_games
```
**Descrição**: Verifica se o PostgreSQL está rodando e aceitando conexões.

### 19. Ver Logs do PostgreSQL
```powershell
docker exec postgres tail -f /var/lib/postgresql/log/postgresql-postgres.log
```
**Descrição**: Exibe os logs do PostgreSQL em tempo real, útil para diagnosticar problemas de conexão ou banco de dados.

### Portas e Conectividade
- **PostgreSQL**: localhost:5433
- **SSH Backup**: localhost:2222
- **SSH PostgreSQL**: localhost:2221

## 🎯 Comandos de Uso Frequente

Para monitoramento diário, use principalmente:
1. `docker compose ps` - Verificar se containers estão rodando
2. `docker exec backup pgbackrest --stanza=postgres info` - Ver status dos backups
3. `docker exec backup pgbackrest --stanza=postgres backup --type=incr` - Criar backup incremental

## 🔧 Configuração Automática

O projeto está configurado para executar automaticamente na inicialização:
```bash
# Aguarda o container postgres ficar disponível
# Configura as chaves SSH conhecidas automaticamente
ssh-keyscan -H postgres >> /var/lib/postgresql/.ssh/known_hosts
```

Isso elimina a necessidade de executar manualmente:
```powershell
docker exec backup bash -c "ssh-keyscan -H postgres >> /var/lib/postgresql/.ssh/known_hosts"
```

