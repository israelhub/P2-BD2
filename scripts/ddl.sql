-- Conecta ao banco postgres
\c postgres;

-- Encerra todas as conexões com o banco steam_games 
SELECT pg_terminate_backend(pid) 
FROM pg_stat_activity 
WHERE datname = 'steam_games' 
AND pid <> pg_backend_pid();

-- Dropa o banco 
DROP DATABASE IF EXISTS steam_games;

-- Cria o banco
CREATE DATABASE steam_games;

-- Conecta com 
\c steam_games;

-- TABELAS PRINCIPAIS

CREATE TABLE categories (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE developers (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE publishers (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE genres (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE tags (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE languages (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE games (
    app_id INT PRIMARY KEY,
    name VARCHAR(255),
    release_date DATE,
    estimated_owners_min INT,
    estimated_owners_max INT,
    current_price DECIMAL(10,2),
    currency_id INT,
    peak_ccu INT,
    required_age INT,
    dlc_count INT,
    about TEXT,
    short_description TEXT,
    header_image_url TEXT,
    website_url TEXT,
    support_url TEXT,
    metacritic_score INT,
    metacritic_url TEXT,
    user_score FLOAT,
    positive_reviews INT,
    negative_reviews INT,
    achievements_count INT,
    recommendations INT,
    average_playtime_forever INT,
    average_playtime_two_weeks INT,
    median_playtime_forever INT,
    median_playtime_two_weeks INT,
    game_status VARCHAR(50),
    is_free BOOLEAN,
    controller_support VARCHAR(50)
);

CREATE TABLE media (
    game_id INT,
    media_type VARCHAR(50),
    url TEXT,
    is_primary BOOLEAN,
    order_index INT,
    FOREIGN KEY (game_id) REFERENCES games(app_id)
);

-- RELACIONAMENTOS

CREATE TABLE game_developers (
    game_id INT,
    developer_id INT,
    PRIMARY KEY (game_id, developer_id),
    FOREIGN KEY (game_id) REFERENCES games(app_id),
    FOREIGN KEY (developer_id) REFERENCES developers(id)
);

CREATE TABLE game_publishers (
    game_id INT,
    publisher_id INT,
    PRIMARY KEY (game_id, publisher_id),
    FOREIGN KEY (game_id) REFERENCES games(app_id),
    FOREIGN KEY (publisher_id) REFERENCES publishers(id)
);

CREATE TABLE game_genres (
    game_id INT,
    genre_id INT,
    is_primary BOOLEAN,
    PRIMARY KEY (game_id, genre_id),
    FOREIGN KEY (game_id) REFERENCES games(app_id),
    FOREIGN KEY (genre_id) REFERENCES genres(id)
);

CREATE TABLE game_tags (
    game_id INT,
    tag_id INT,
    votes INT,
    PRIMARY KEY (game_id, tag_id),
    FOREIGN KEY (game_id) REFERENCES games(app_id),
    FOREIGN KEY (tag_id) REFERENCES tags(id)
);

CREATE TABLE game_categories (
    game_id INT,
    category_id INT,
    PRIMARY KEY (game_id, category_id),
    FOREIGN KEY (game_id) REFERENCES games(app_id),
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE game_full_audio_languages (
    game_id INT,
    language_id INT,
    PRIMARY KEY (game_id, language_id),
    FOREIGN KEY (game_id) REFERENCES games(app_id),
    FOREIGN KEY (language_id) REFERENCES languages(id)
);

CREATE TABLE game_supported_languages (
    game_id INT,
    language_id INT,
    interface_support BOOLEAN,
    subtitles_support BOOLEAN,
    PRIMARY KEY (game_id, language_id),
    FOREIGN KEY (game_id) REFERENCES games(app_id),
    FOREIGN KEY (language_id) REFERENCES languages(id)
);


-- ÍNDICES PARA AS TABELAS PRINCIPAIS

-- Índices para busca por nome (muito comum em consultas)
CREATE INDEX idx_categories_name ON categories(name);
CREATE INDEX idx_developers_name ON developers(name);
CREATE INDEX idx_publishers_name ON publishers(name);
CREATE INDEX idx_genres_name ON genres(name);
CREATE INDEX idx_tags_name ON tags(name);
CREATE INDEX idx_languages_name ON languages(name);

-- ÍNDICES PARA AS TABELA GAMES

-- Busca por nome do jogo (consulta muito frequente)
CREATE INDEX idx_games_name ON games(name);

-- Busca por data de lançamento (consultas de intervalos de tempo)
CREATE INDEX idx_games_release_date ON games(release_date);

-- Busca por preço (ordenação e filtros por faixa de preço)
CREATE INDEX idx_games_current_price ON games(current_price);

-- Busca por faixa de proprietários estimados (análises de popularidade)
CREATE INDEX idx_games_estimated_owners ON games(estimated_owners_min, estimated_owners_max);

-- Busca por avaliações metacritic (filtros por qualidade)
CREATE INDEX idx_games_metacritic_score ON games(metacritic_score);

-- Busca por avaliações de usuários
CREATE INDEX idx_games_user_score ON games(user_score);

-- Busca por jogos gratuitos (filtro comum)
CREATE INDEX idx_games_is_free ON games(is_free);

-- Busca por status do jogo
CREATE INDEX idx_games_status ON games(game_status);

-- Busca por idade requerida (filtros parentais)
CREATE INDEX idx_games_required_age ON games(required_age);

-- Índice composto para análises de reviews
CREATE INDEX idx_games_reviews ON games(positive_reviews, negative_reviews);

-- Índice para tempo de jogo médio (análises de engajamento)
CREATE INDEX idx_games_playtime ON games(average_playtime_forever);

-- ÍNDICES PARA AS TABELAS DE RELACIONAMENTO

-- game_developers: busca jogos por desenvolvedor
CREATE INDEX idx_game_developers_developer ON game_developers(developer_id);

-- game_publishers: busca jogos por publisher
CREATE INDEX idx_game_publishers_publisher ON game_publishers(publisher_id);

-- game_genres: busca jogos por gênero e gêneros primários
CREATE INDEX idx_game_genres_genre ON game_genres(genre_id);
CREATE INDEX idx_game_genres_primary ON game_genres(is_primary);
CREATE INDEX idx_game_genres_genre_primary ON game_genres(genre_id, is_primary);

-- game_tags: busca jogos por tag e ordenação por votos
CREATE INDEX idx_game_tags_tag ON game_tags(tag_id);
CREATE INDEX idx_game_tags_votes ON game_tags(votes DESC);
CREATE INDEX idx_game_tags_tag_votes ON game_tags(tag_id, votes DESC);

-- game_categories: busca jogos por categoria
CREATE INDEX idx_game_categories_category ON game_categories(category_id);

-- game_full_audio_languages: busca jogos por idioma de áudio
CREATE INDEX idx_game_full_audio_lang ON game_full_audio_languages(language_id);

-- game_supported_languages: busca suporte específico de idioma
CREATE INDEX idx_game_supported_lang ON game_supported_languages(language_id);
CREATE INDEX idx_game_supported_interface ON game_supported_languages(interface_support);
CREATE INDEX idx_game_supported_subtitles ON game_supported_languages(subtitles_support);

-- media: busca mídia por tipo e ordenação
CREATE INDEX idx_media_type ON media(media_type);
CREATE INDEX idx_media_primary ON media(is_primary);
CREATE INDEX idx_media_order ON media(game_id, order_index);
CREATE INDEX idx_media_type_primary ON media(media_type, is_primary);