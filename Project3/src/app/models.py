'''
DSML 3850 - Cloud Computing - Spring 2025
Instructor: Thyago Mota
Student: Jeremy Dougherty
Description: Project 3 - Heart Attack Predictor
'''

from app import db 
from flask_login import UserMixin
import joblib
import os

class User(db.Model, UserMixin):
    __tablename__ = 'users'
    id = db.Column(db.String, primary_key=True)
    name = db.Column(db.String)
    email = db.Column(db.String)
    password = db.Column(db.LargeBinary)

class HeartAttackPredictor(): 
    
    def __init__(self):
        base_path = os.path.dirname(__file__)

        # Load the model from the file
        model_path = os.path.join(base_path, 'logistic_model.pkl')
        self.model = joblib.load(model_path)

        # Load the scaler from the file 
        scaler_path = os.path.join(base_path, 'scaler.pkl')
        self.scaler = joblib.load(scaler_path)

    def predict(self, data):
        # Scale the data
        data_scaled = self.scaler.transform(data)

        # Make prediction
        prediction = self.model.predict(data_scaled)

        return prediction
