## 📋 Documentação Completa

**📚 [Leia a documentação completa em DOCUMENTATION.md](./docs/DOCUMENTATION.md)**

A documentação detalha:
- ✅ Análise comparativa entre arquivo original e estrutura normalizada
- ✅ Justificativas técnicas para cada melhoria implementada
- ✅ Estratégia completa de indexação com impactos de performance
- ✅ Migração para pgloader com configuração otimizada

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

### 4. Subir os serviços
```bash
docker compose up -d
```
