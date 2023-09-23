import sqlite3
import logging

logger = logging.getLogger('werkzeug')
handler = logging.FileHandler('site-log.log')
logger.addHandler(handler)

class Database():

    def __init__(self):
        logger.info('starting database connection')
        self.connection = sqlite3.connect('company_stock.db', check_same_thread=False, timeout=10)
        self.query = self.connection.cursor()
        logger.info('Database connected.')

        with open('company_stock.sql', 'r') as sql_file:
            sql_script = sql_file.read()

        self.query.executescript(sql_script)
        self.connection.commit()

    def user_exists(self, email: str, password: str) -> bool:

        self.query.execute(f"SELECT * FROM usuario WHERE email == '{email}' AND password == '{str(hash(password))}'")
        logger.info(f"SELECT * FROM usuario WHERE email == '{email}' AND password == '{str(hash(password))}'")

        account = self.query.fetchone()

        if not account:
            return False
        
        return True
    
    def insert_user(self, email: str, password: str, password_c: str) -> bool:
        
        if len(email) > 300:
            return False
        
        elif len(password)> 64:
            return False
        
        elif hash(password_c) != hash(password):
            return False
                
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

        self.query.execute(f"SELECT id FROM usuario WHERE email == '{email}' AND password == '{password}'")
        logger.info(f"SELECT id FROM usuario WHERE email == '{email}' AND password == '{password}'")

        user_id = self.query.fetchone()

        logger.info(f"user_id:{user_id}")
        
        return user_id[0]
    
    def alter_password(self, user_id, password):

        self.query.execute(f"UPDATE usuario SET password = '{str(hash(password))}' WHERE id == {user_id}")
        logger.info(f"UPDATE usuario SET password = '{str(hash(password))}' WHERE id == {user_id}")

        self.connection.commit()

    def alter_email(self, user_id, email):
        self.query.execute(f"UPDATE usuario SET email = '{email}' WHERE id == {user_id}")
        logger.info(f"UPDATE usuario SET email = '{email}' WHERE id == {user_id}")
        self.connection.commit()

    def is_admin(self, user_id):
        self.query.execute(f"SELECT is_admin FROM usuario WHERE id == {user_id}")
        logger.info(f"SELECT is_admin FROM usuario WHERE id == {user_id}")

        is_admin = self.query.fetchone()[0]
        
        return is_admin

    def get_suppliers(self):
        self.query.execute("SELECT nome FROM fornecedor")
        suppliers = self.query.fetchall()

        return suppliers
    
    def get_material_name(self, material_id):
        self.query.execute(f"SELECT nome FROM material WHERE id == {material_id}")
        material_name = self.query.fetchone()[0]

        return material_name