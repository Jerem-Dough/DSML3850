'''
DSML3850 - Cloud Computing - Spring 2025
Instructor: Thyago Mota
'''

from app import app, container_id

@app.route('/a')
@app.route('/b')
def index(): 
    return f'Container\'s ID: {container_id}'
