from flask import Flask, redirect, url_for, request, render_template, Blueprint, flash, session, abort
from flask import Flask
from database import Database
import logging
import os
import math
import sqlite3
import requests
import urllib.parse
import hashlib



logger = logging.getLogger('werkzeug')
handler = logging.FileHandler('site-log.log')
logger.addHandler(handler)

app = Flask(__name__)
app.secret_key = '1234'
site = Blueprint('site', __name__, template_folder='templates')

database = Database()
 
@app.route("/")
def index():
    if 'logged_in' in session:
        return render_template('index.html')
    else:
       return redirect(url_for('login'))
        

@app.route("/index")
def index_redirect():
       return redirect(url_for('index'))
    
@app.route('/login', methods=['GET', 'POST'])
def login():

    is_login_valid = True

    if request.method == 'POST' and 'email' in request.form and 'password' in request.form:
        
        # Create variables for easy access
        email = request.form['email']
        password = request.form['password']

        if database.user_exists(email, password):

            session['logged_in'] = True
            session['user_id'] = database.get_user_id(email, password)

            return redirect(url_for(f'index'))
        else:
            is_login_valid = False
    
    return render_template('auth/login.html', is_login_valid = is_login_valid)

@app.route("/register", methods=['GET','POST'])
def register():

    is_password_valid = True
    is_email_valid = True

    if (request.method == 'POST' and 'email' in request.form and 'password' in request.form and 'password_c' in request.form):
        
        email = request.form['email']
        password = request.form['password']
        password_c = request.form['password_c']

        if database.insert_user(email, password, password_c):
            return redirect(url_for('login'))
        
        else:
            if len(email) > 300:
                is_email_valid = False

            elif len(password)> 64:
                is_password_valid = False

            elif password_c != password:
                is_password_valid = False                
    
    return render_template('auth/register.html', is_password_valid = is_password_valid, is_email_valid = is_email_valid)

@app.route('/fornecedor', methods=['GET', 'POST'])
def fornecedor():
    return render_template('fornecedor/index.html', fornecedores = database.get_suppliers(), is_admin = True)

@app.route('/fornecedor/create', methods=['GET', 'POST'])
def create_fornecedor():

    if (request.method == 'POST' and 'supplier_name' in request.form):
        
        supplier_name = request.form['supplier_name']

        if database.insert_supplier(supplier_name):
            return redirect(url_for('fornecedor'))  
        
    return redirect(url_for('fornecedor'))

@app.route('/fornecedor/update/<id>', methods=['GET', 'POST'])
def update_fornecedor(id):

    if (request.method == 'POST' and 'supplier_name' in request.form):
        
        supplier_name = request.form['supplier_name']

        if database.update_supplier(id, supplier_name):
            return redirect(url_for('fornecedor'))  
        
    return redirect(url_for('fornecedor'))

@app.route('/fornecedor/delete/<id>', methods=['GET', 'POST'])
def delete_fornecedor(id):
    database.delete_supplier(id)
    return redirect(url_for('fornecedor'))

if __name__ == '__main__':
    app.run(debug=True)