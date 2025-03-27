'''
DSML3850 - Cloud Computing - Spring 2025
Instructor: Thyago Mota
'''

from flask import Flask
import uuid

# Generate a unique identifier for the container
container_id = str(uuid.uuid4())[:8]

app = Flask("Web App")

from app import routes