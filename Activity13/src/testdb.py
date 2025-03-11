'''
DSML3850 - Cloud Computing - Spring 2025
Instructor: Thyago Mota
'''

import psycopg2
import configparser as cp

config = cp.RawConfigParser()
config.read('db.ini')
params = dict(config.items('db'))

conn = psycopg2.connect(**params)
if conn: 
    print('Connection to Postgres database ' + params['dbname'] + ' was successful!')
    conn.close()
