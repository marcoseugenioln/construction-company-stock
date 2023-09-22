-- SQL de criação do banco de dados para a ferramenta minhaFacul

-- fornecedor definition
CREATE TABLE IF NOT EXISTS fornecedor (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome TEXT(300),
	CONSTRAINT FACULDADE_UN UNIQUE (nome)
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

-- usuario definition
CREATE TABLE IF NOT EXISTS usuario (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	email TEXT(300),
	password TEXT(64),
	is_admin INTEGER DEFAULT (0),
	CONSTRAINT USUARIO_UN UNIQUE (email)
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

-- Comparativo entre faculdades para o ano atual e ultimos dois
-- CREATE VIEW  IF NOT EXISTS COMPARATIVO AS
-- SELECT A.FACULDADE_ID, A.CURSO_ID, D.FACULADE, E.CURSO, D.LOCAL_LAT, D.LOCAL_LON,
-- 	CAST(CAST(A.CANDIDATOS AS REAL) / CAST(A.VAGAS AS REAL) AS REAL(10,2)) AS CPV,
-- 	CAST(CAST(B.CANDIDATOS AS REAL) / CAST(B.VAGAS AS REAL) AS REAL(10,2)) AS CPV_1,
-- 	CAST(CAST(C.CANDIDATOS AS REAL) / CAST(C.VAGAS AS REAL) AS REAL(10,2)) AS CPV_2
-- FROM
--     (SELECT * FROM HISTORICO WHERE ANO = strftime('%Y', 'now')) AS A
-- LEFT JOIN
--     (SELECT * FROM HISTORICO WHERE ANO = strftime('%Y', 'now')-1) AS B
-- USING (FACULDADE_ID, CURSO_ID)
-- LEFT JOIN
--     (SELECT * FROM HISTORICO WHERE ANO = strftime('%Y', 'now')-2) AS C
-- USING (FACULDADE_ID, CURSO_ID)
-- LEFT JOIN
--     FACULDADE AS D
-- USING (FACULDADE_ID)
-- LEFT JOIN
--     CURSO AS E
-- USING (CURSO_ID);

-- CREATE VIEW IF NOT EXISTS HISTORICO_DET AS
-- SELECT A.HISTORICO_ID, A.FACULDADE_ID, A.CURSO_ID, D.FACULADE, E.CURSO,	A.ANO, A.CANDIDATOS, A.VAGAS
-- FROM HISTORICO AS A
-- LEFT JOIN
--     FACULDADE AS D
-- USING (FACULDADE_ID)
-- LEFT JOIN
--     CURSO AS E
-- USING (CURSO_ID);

--########################################################
--#    DADOS DE "REAIS" PARA PRODUÇÃO USAR COM CUIDADO!  #
--########################################################

-- INSERT OR IGNORE INTO USUARIO	(EMAIL, SENHA_SHA256, RECUPERA_SENHA, ADMINISTRADOR, CURSO_ID, LOCAL_TXT, LOCAL_LAT, LOCAL_LON)
-- VALUES
--     ('eu@dot.com', 'root', 0, 0, 1, '', 0, 0);
