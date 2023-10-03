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
	usuario_id INTEGER DEFAULT(1),
	data DATE DEFAULT(DATE('now')),
	status INTEGER DEFAULT(1),
	CONSTRAINT pedido_fk FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);

-- item definition
CREATE TABLE IF NOT EXISTS item (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	pedido_id INTEGER,
	material_id INTEGER,
	quantidade INTEGER,
	CONSTRAINT pedido_fk_1 FOREIGN KEY (pedido_id) REFERENCES pedido(id),
	CONSTRAINT pedido_fk_2 FOREIGN KEY (material_id) REFERENCES material(id)
);

--########################################################
--#          DADOS DE "REAIS" PARA PRODUÇÃO              #
--########################################################

INSERT OR IGNORE INTO usuario (email, password, is_admin) VALUES ('root@root.com', 'root', 1);
INSERT OR IGNORE INTO usuario (email, password, is_admin) VALUES ('marcos@root.com', 'root', 1);
INSERT OR IGNORE INTO usuario (email, password, is_admin) VALUES ('catilho@root.com', 'root', 1);
INSERT OR IGNORE INTO usuario (email, password, is_admin) VALUES ('user@user.com', 'user', 0);


INSERT OR IGNORE INTO fornecedor(id, nome) VALUES (0, '');
INSERT OR IGNORE INTO fornecedor(nome) VALUES ('Materiais de Construção S.A');
INSERT OR IGNORE INTO fornecedor(nome) VALUES ('Construindo Bem S.A');
INSERT OR IGNORE INTO fornecedor(nome) VALUES ('Nilo');
INSERT OR IGNORE INTO fornecedor(nome) VALUES ('Loja de Materiais');
INSERT OR IGNORE INTO fornecedor(nome) VALUES ('Construtora da Vila');
INSERT OR IGNORE INTO fornecedor(nome) VALUES ('Construtora Quebra Tudo');
INSERT OR IGNORE INTO fornecedor(nome) VALUES ('Deposito da Vila');
INSERT OR IGNORE INTO fornecedor(nome) VALUES ('Deposito Alves');
INSERT OR IGNORE INTO fornecedor(nome) VALUES ('Alfa Materiais Hidraulicos');
INSERT OR IGNORE INTO fornecedor(nome) VALUES ('Construindo Sobre Areia S.A');

INSERT OR IGNORE INTO material (id, fornecedor_id, nome, valor, estoque, estoque_minimo) VALUES (0, 0, '', 0, 0, 0);
INSERT OR IGNORE INTO material (fornecedor_id, nome, valor, estoque, estoque_minimo) VALUES (1, 'Saco de Cimento 50kg', 100, 0, 0);
INSERT OR IGNORE INTO material (fornecedor_id, nome, valor, estoque, estoque_minimo) VALUES (1, 'Saco de Areia 50kg', 20, 0, 0);
INSERT OR IGNORE INTO material (fornecedor_id, nome, valor, estoque, estoque_minimo) VALUES (2, 'Ripa de Madeira 5m', 10, 0, 0);
INSERT OR IGNORE INTO material (fornecedor_id, nome, valor, estoque, estoque_minimo) VALUES (2, 'Ripa de Madeira 10m', 20, 0, 0);
INSERT OR IGNORE INTO material (fornecedor_id, nome, valor, estoque, estoque_minimo) VALUES (3, 'Tabua de Madeira 5m', 20, 0, 0);
INSERT OR IGNORE INTO material (fornecedor_id, nome, valor, estoque, estoque_minimo) VALUES (3, 'Tabua de Madeira 10m', 40, 0, 0);
INSERT OR IGNORE INTO material (fornecedor_id, nome, valor, estoque, estoque_minimo) VALUES (4, 'Chave de Fenda', 10, 0, 0);
INSERT OR IGNORE INTO material (fornecedor_id, nome, valor, estoque, estoque_minimo) VALUES (4, 'Chave de Philips', 10, 0, 0);
INSERT OR IGNORE INTO material (fornecedor_id, nome, valor, estoque, estoque_minimo) VALUES (5, 'Chave de Boca 8mm', 10, 0, 0);
INSERT OR IGNORE INTO material (fornecedor_id, nome, valor, estoque, estoque_minimo) VALUES (5, 'Chave de Boca 5mm', 10, 0, 0);



INSERT OR IGNORE INTO pedido (id, usuario_id, data, status) VALUES (1, 1, DATE('now'), 1);

