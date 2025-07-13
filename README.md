# Projeto P2 - Banco de Dados 2: Steam Data

Este projeto tem como objetivo implementar um ambiente PostgreSQL para realizar a migração de dados de uma base monolítica do Steam para um banco de dados PostgreSQL normalizado, otimizado e programável. Além disso, o projeto contempla a criação de uma estrutura completa com:

 • Backup gerenciado com pgBackRest;
 • Monitoramento contínuo por meio do Prometheus e Grafana;
 • Ambiente de Data Warehouse;
 • Processos de ELT orquestrados com Apache Airflow;
 • Visualização de dados com Apache Superset.

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

## 🚀 Como usar o Ambiente

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

### 4. Subir os serviços do docker com Docker Compose
```bash
docker compose up -d 
```

# 📄 Documentação

**📚 [Leia a documentação de modelagem e indexação em DOCUMENTATION.md](./docs/MODELAGEM.md)**

A documentação detalha:
- ✅ Análise comparativa entre arquivo original e estrutura normalizada
- ✅ Justificativas técnicas para cada melhoria implementada
- ✅ Estratégia completa de indexação com impactos de performance
- ✅ Migração para pgloader com configuração otimizada

**📚 [Leia a documentação dos comandos de backup em BACKUP_COMMANDS.md](./docs/COMANDOS_BACKUP.md)**

A documentação de backup inclui:
- ✅ Comandos para criação, restauração e manutenção de backups com pgBackRest
- ✅ Estratégias de monitoramento e logs

**📚 [Leia o dicionário de dados em DICIONARIO_DE_DADOS.md](./docs/DICIONARIO_DE_DADOS.md)**

O dicionário de dados contém:
- ✅ Estrutura detalhada do banco de dados normalizado
- ✅ Descrições de tabelas, colunas e relacionamentos

**📚 [Veja exemplo de gráficos criados com Apache Superset](./superset/README.md)**

O Readme do Superset inclui:
- ✅ Exemplo de consultas SQL para visualização de dados
- ✅ Passo a passo para iniciar o Apache Superset
- ✅ Captura do Dashboard de visualização de dados criado para análise do Data Warehouse