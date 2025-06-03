'''
DSML 3850 - Cloud Computing - Spring 2025
Instructor: Thyago Mota
Student: Jeremy Dougherty
Description: Project 3 - Heart Attack Predictor
'''

from flask import Flask
import configparser as cp
import os

# Resolve paths to templates and static directories inside src/app/
base_path = os.path.dirname(__file__)
template_dir = os.path.join(base_path, 'templates')
static_dir = os.path.join(base_path, 'static')

# Initialize Flask app with explicit template/static folder paths
app = Flask('Heart Attack Predictor', template_folder=template_dir, static_folder=static_dir)

# consider using an ENVIRONMENT VARIABLE to improve security
app.secret_key = 'you-will-never-guess'

# db initialization
print('db initialization started')
config = cp.RawConfigParser()
config.read(os.path.join(base_path, 'config.ini'))
params = dict(config.items('db'))

from flask_sqlalchemy import SQLAlchemy
db = SQLAlchemy()
app.config['SQLALCHEMY_DATABASE_URI'] = f"postgresql://{params['user']}:{params['password']}@{params['host']}:{params['port']}/postgres"
db.init_app(app)
print('db initialization completed!')

# db from models
from . import models
with app.app_context():
    db.create_all()

# login manager
from flask_login import LoginManager
login_manager = LoginManager()
login_manager.init_app(app)

from .models import User

# user_loader callback
@login_manager.user_loader
def load_user(id):
    try:
        return db.session.query(User).filter(User.id == id).one()
    except:
        return None

# Heart attack predictor
heart_attack_predictor = models.HeartAttackPredictor()

from . import routes
