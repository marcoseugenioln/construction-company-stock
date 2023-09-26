-- usuario definition
CREATE TABLE IF NOT EXISTS usuario (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	email TEXT(300),
	password TEXT(64),
	is_admin INTEGER DEFAULT (0),
	CONSTRAINT usuario_un UNIQUE (email)
);

-- fornecedor definition
CREATE TABLE IF NOT EXISTS fornecedor (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome TEXT(300),
	CONSTRAINT fornecedor_un UNIQUE (nome)
);

-- material definition
CREATE TABLE IF NOT EXISTS material (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	fornecedor_id INTEGER,
	nome TEXT(300),
	valor INTEGER,
	estoque INTEGER,
	estoque_minimo INTEGER,
	CONSTRAINT material_un UNIQUE (nome),
	CONSTRAINT material_fk FOREIGN KEY (fornecedor_id) REFERENCES fornecedor(id)
);

-- pedido definition
CREATE TABLE IF NOT EXISTS pedido (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	usuario_id INTEGER,
	data_compra DATE,
	CONSTRAINT pedido_fk FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);

-- item definition
CREATE TABLE IF NOT EXISTS item (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	pedido_id INTEGER,
	material_id INTEGER,
	quantidade INTEGER,
	CONSTRAINT pedido_un UNIQUE (material_id),
	CONSTRAINT pedido_fk_1 FOREIGN KEY (pedido_id) REFERENCES pedido(id),
	CONSTRAINT pedido_fk_2 FOREIGN KEY (material_id) REFERENCES material(id)
);

--########################################################
--#          DADOS DE "REAIS" PARA PRODUÇÃO              #
--########################################################

INSERT OR IGNORE INTO usuario (email, password, is_admin) VALUES ('root@root.com', '-5078283684866250020', 1);
