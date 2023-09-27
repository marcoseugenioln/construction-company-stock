import sqlite3
import logging

logger = logging.getLogger('werkzeug')
handler = logging.FileHandler('site-log.log')
logger.addHandler(handler)

class Database():

    def __init__(self):
        logger.info('starting database connection')
        self.connection = sqlite3.connect('schema.db', check_same_thread=False, timeout=10)
        self.query = self.connection.cursor()
        logger.info('Database connected.')

        with open('schema.sql', 'r') as sql_file:
            sql_script = sql_file.read()

        self.query.executescript(sql_script)
        self.connection.commit()

    def user_exists(self, email: str, password: str) -> bool:

        self.query.execute(f"SELECT * FROM usuario WHERE email == '{email}' AND password == '{password}'")
        logger.info(f"SELECT * FROM usuario WHERE email == '{email}' AND password == '{password}'")

        account = self.query.fetchone()

        if not account:
            return False
        
        return True
    
    def insert_user(self, email: str, password: str, password_c: str) -> bool:        
        self.query.execute(f"INSERT OR IGNORE INTO usuario(email, password) values ('{email}', '{password}');")
        logger.info(f"INSERT OR IGNORE INTO usuario(email, password) values ('{email}', '{password}');")
        self.connection.commit()
        return True
    
    def get_user_email(self, user_id: int) -> str:
        self.query.execute(f"SELECT email FROM usuario WHERE id == '{user_id}'")
        logger.info(f"SELECT email FROM usuario WHERE id == '{user_id}'")
        email = self.query.fetchone()
        return email[0]

    def get_user_id(self, email: str, password: str):
        self.query.execute(f"SELECT id FROM usuario WHERE email == '{email}' AND password == '{hash(str(password))}'")
        logger.info(f"SELECT id FROM usuario WHERE email == '{email}' AND password == '{password}'")
        user_id = self.query.fetchone()        
        return user_id
    
    def alter_password(self, user_id, password):
        self.query.execute(f"UPDATE usuario SET password = '{password}' WHERE id == {user_id}")
        logger.info(f"UPDATE usuario SET password = '{password}' WHERE id == {user_id}")
        self.connection.commit()

    def alter_email(self, user_id, email):
        self.query.execute(f"UPDATE usuario SET email = '{email}' WHERE id == {user_id}")
        logger.info(f"UPDATE usuario SET email = '{email}' WHERE id == {user_id}")
        self.connection.commit()

    def is_admin(self, user_id):
        self.query.execute(f"SELECT is_admin FROM usuario WHERE id == {user_id}")
        logger.info(f"SELECT is_admin FROM usuario WHERE id == {user_id}")
        is_admin = self.query.fetchone()
        return is_admin

    def get_suppliers(self):
        self.query.execute("SELECT id, nome FROM fornecedor")
        suppliers = self.query.fetchall()
        return suppliers
    
    def insert_supplier(self, name):
        self.query.execute(f"INSERT OR IGNORE INTO fornecedor (nome) VALUES ('{name}');")
        logger.info(f"INSERT OR IGNORE INTO fornecedor (nome) VALUES ('{name}');")
        self.connection.commit()
        return True
    
    def delete_supplier(self, id):
        self.query.execute(f"DELETE FROM fornecedor WHERE id == {id};")
        logger.info(f"DELETE FROM fornecedor WHERE id == {id};")
        self.connection.commit()

    def update_supplier(self, id, supplier_name):
        self.query.execute(f"UPDATE fornecedor SET nome = '{supplier_name}' WHERE id == {id};")
        logger.info(f"UPDATE fornecedor SET nome = '{supplier_name}' WHERE id == {id};")
        self.connection.commit()
    
    def get_materials(self):
        self.query.execute("SELECT id, fornecedor_id, nome, valor, estoque, estoque_minimo FROM material")
        materials = self.query.fetchall()
        return materials
    
    def insert_material(self, supplier_id, name, value, stock, min_stock):
        self.query.execute(f"INSERT OR IGNORE INTO material (fornecedor_id, nome, valor, estoque, estoque_minimo) VALUES ({supplier_id}, '{name}', {value}, {stock}, {min_stock});")
        logger.info(f"INSERT OR IGNORE INTO material (fornecedor_id, nome, valor, estoque, estoque_minimo) VALUES ({supplier_id}, '{name}', {value}, {stock}, {min_stock});")
        self.connection.commit()
        return True
    
    def update_material(self, id, supplier_id, name, value, stock, min_stock):
        self.query.execute(f"UPDATE material SET fornecedor_id = {supplier_id}, nome = '{name}', valor = {value}, estoque = {stock}, estoque_minimo = {min_stock} WHERE id == {id};")
        logger.info(f"UPDATE material SET fornecedor_id = {supplier_id}, nome = '{name}', valor = {value}, estoque = {stock}, estoque_minimo = {min_stock} WHERE id == {id};")
        self.connection.commit()

    def delete_material(self, id):
        self.query.execute(f"DELETE FROM material WHERE id == {id};")
        logger.info(f"DELETE FROM material WHERE id == {id};")
        self.connection.commit()