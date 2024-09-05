import sqlite3
import os
import constants
import argparse

def create_db():
    filepath = constants.AUTH_DATABASE_FILENAME
    if(os.path.exists(filepath)):
        os.remove(filepath)
    
    conn = sqlite3.connect(filepath)

    c = conn.cursor()
    c.execute(constants.AUTH_TABLE_SCHEMA)
    c.close()


if __name__ == "__main__":
    # parser = argparse.ArgumentParser(
    #                 prog='ProgramName',
    #                 description='What the program does',
    #                 epilog='Text at the bottom of help')
    # parser.add_argument('--create-db', action='store_true', help='Create the database')
    # parser.add_arguemnt('--clear-table', action='store_true', help='Clear the database')
    # args = parser.parse_args()

    filepath = constants.AUTH_DATABASE_FILENAME
    if(os.path.exists(filepath)):
        os.remove(filepath)
    
    conn = sqlite3.connect(filepath)

    c = conn.cursor()
    c.execute(constants.AUTH_TABLE_SCHEMA)
    c.close()