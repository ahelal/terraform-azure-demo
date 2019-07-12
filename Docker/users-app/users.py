#!/usr/bin/env python

import mysql.connector
import os

from flask import Flask, render_template, request
from mysql.connector import errorcode

app = Flask(__name__)

class Database:
    def __init__(self, host, user, password, db):
        self.host = host
        self.user = user
        self.password = password
        self.db = db

    def connect(self):
        ssl_ca_path = os.path.join(os.path.realpath(__file__),"../BaltimoreCyberTrustRoot.crt.pem") 
        self.cnx = mysql.connector.connect(user=self.user, password=self.password, host=self.host, port=3306, database=self.db,  ssl_verify_cert=True, ssl_ca=ssl_ca_path)
        self.cur = self.cnx.cursor()

    def close(self):
        self.cnx.commit()
        self.cur.close()

    def setup(self):
        try:
            print("Creating table {}: ".format('MyUsers'), end='')
            self.cur.execute("CREATE TABLE MyUsers ( firstname VARCHAR(30) NOT NULL,  lastname VARCHAR(30) NOT NULL);")
        except mysql.connector.Error as err:
            if err.errno == errorcode.ER_TABLE_EXISTS_ERROR:
                print("Skipping already exists.")
            else:
                print(err.msg)
                exit(1) 


@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == "POST":
        details = request.form

        # re.sub(r'\W+', '', your_string)
        firstName = details['fname']
        lastName = details['lname']
        db.cur.execute("INSERT INTO MyUsers(firstName, lastName) VALUES (%s, %s)", (firstName, lastName))
        db.close()
        return 'success'
    return render_template('index.html')

@app.route('/list', methods=['GET'])
def list_users():
    db.connect()
    db.cur.execute("select * from  MyUsers;")
    users_result = db.cur.fetchall()
    db.close()
    users_dic = { i : users_result[i] for i in range(0, len(users_result) ) }
    return users_dic


@app.route('/health', methods=['GET'])
def health():
    try:
        db.connect()
        db.close()
    except:
        return "not healthy :(", 503
    return "all is good", 200

if __name__ == '__main__':
    # Config
    host = os.getenv('APP_DB_HOST')
    user = os.getenv('APP_DB_USER')
    password = os.getenv('APP_DB_PASS')
    db = os.getenv('APP_DB_NAME', 'mariadb_database') 
    port = os.getenv('APP_PORT', 5000)

    # setup maria db class
    db = Database(host, user, password, db)
    db.connect()
    db.setup()
    
    # Run app
    app.run(host='0.0.0.0', port=int(port))