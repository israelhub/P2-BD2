# Projeto P2 - Banco de Dados 2: Steam Data

Este projeto tem como objetivo implementar um ambiente PostgreSQL robusto para realizar a migração de dados de uma base monolítica do Steam para um banco de dados PostgreSQL normalizado, otimizado e programável. Além disso, o projeto contempla a criação de uma estrutura completa com:

 • Backup gerenciado com pgBackRest;
 • Monitoramento contínuo por meio do Prometheus e Grafana;
 • Ambiente de Data Warehouse;
 • Processos de ETL orquestrados com Apache Airflow.

## 📦 Git LFS

Este projeto utiliza Git Large File Storage (LFS) para gerenciar arquivos grandes. Os seguintes arquivos são rastreados com Git LFS:
- `data/games.csv` (207.36 MB)
- `output/games.csv` (98.48 MB)
- `output/media.csv` (91.73 MB)

### Configurando Git LFS

Se você não tem o Git LFS instalado, [instale-o primeiro](https://git-lfs.github.com/).

```bash
# Instale o Git LFS
git lfs install

# Clone o repositório
git clone <URL_DO_REPOSITORIO>
cd steam-data

# Verifique se os arquivos LFS foram baixados corretamente
git lfs ls-files
```

## 🚀 Como usar a API

### 1. Clonar o repositório
```bash
git clone <URL_DO_REPOSITORIO>
```

### 2. Navegar até o diretório do projeto
```bash
cd steam-data
```

### 3. Configurar as variáveis de ambiente
Crie um arquivo `.env` com as variaveis necessárias no .env.example:
```bash
cp .env.example .env
```

### 4. Subir os serviços de banco de dados e backup
```bash
docker compose up -d postgres backup
```

### 5. Subir o serviço da API para migrar os dados para o banco de dados
```bash
docker compose up -d api
```

# 📄 Documentação

**📚 [Leia a documentação de modelagem e indexação em DOCUMENTATION.md](./docs/DOCUMENTATION.md)**

A documentação detalha:
- ✅ Análise comparativa entre arquivo original e estrutura normalizada
- ✅ Justificativas técnicas para cada melhoria implementada
- ✅ Estratégia completa de indexação com impactos de performance
- ✅ Migração para pgloader com configuração otimizada

**📚 [Leia a documentação dos comandos de backup em BACKUP_COMMANDS.md](./docs/BACKUP_COMMANDS.md)**

A documentação de backup inclui:
- ✅ Comandos para criação, restauração e manutenção de backups com pgBackRest
- ✅ Estratégias de monitoramento e logs

**📚 [Leia o dicionário de dados em DICIONARIO_DE_DADOS.md](./docs/DICIONARIO_DE_DADOS.md)**

O dicionário de dados contém:
- ✅ Estrutura detalhada do banco de dados normalizado
- ✅ Descrições de tabelas, colunas e relacionamentos