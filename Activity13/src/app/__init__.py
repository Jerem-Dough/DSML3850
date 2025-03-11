'''
DSML3850 - Cloud Computing - Spring 2025
Instructor: Thyago Mota
'''

from flask import Flask
import configparser as cp

app = Flask("Web App")

# consider using an environment variable for extra security
app.secret_key = 'do not share'

# db.ini parse
config = cp.RawConfigParser()
config.read('db.ini')
params = dict(config.items('db'))

# db initialization
from flask_sqlalchemy import SQLAlchemy
db = SQLAlchemy()
app.config['SQLALCHEMY_DATABASE_URI'] = f'postgresql://{params["user"]}:{params["password"]}@{params["host"]}:{params["port"]}/{params["dbname"]}'
db.init_app(app)

from app import models
with app.app_context(): 
    db.create_all()

# login manager
from flask_login import LoginManager
login_manager = LoginManager()
login_manager.init_app(app)

from app.models import User

# user_loader callback
@login_manager.user_loader
def load_user(id):
    try: 
        return db.session.query(User).filter(User.id==id).one()
    except: 
        return None

from app import routes