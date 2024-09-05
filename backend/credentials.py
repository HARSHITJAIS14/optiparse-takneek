import sqlite3
import constants
import transactions_processing

def signup(username: str, password: str):
    conn = sqlite3.connect('credentials.db')
    c = conn.cursor()
    c.execute(constants.AUTH_TABLE_INSERT, (username, password))
    c.execute(constants.GET_ID_QUERY, (username,))
    user_id = c.fetchone()[0]
    c.execute(constants.create_transaction_table_query(user_id))
    conn.commit()
    conn.close()

def update_users(userid: str, account_number: str, email_id: str, phone_number: str, pan_number: str, aadhar_number: str):
    conn = sqlite3.connect('credentials.db')
    c = conn.cursor()
    # c.execute('UPDATE credentials SET account_number = ?, email_id = ? WHERE userid = ?', (account_number, email_id, userid))
    c.execute('UPDATE credentials SET account_number = ?, email_id = ?, phone_number = ?, pan_number = ?, aadhar_number = ? WHERE userid = ?', (account_number, email_id, phone_number, pan_number, aadhar_number, userid))
    conn.commit()
    conn.close()

    


def get_user(userid: str, is_token: bool = False):
    if is_token:
        pass
        
    conn = sqlite3.connect('credentials.db')
    c = conn.cursor()
    c.execute('SELECT id, userid, password, account_number, email_id, pan_number, aadhar_number, phone_number FROM credentials WHERE userid = ?', (userid,))
    
    user = c.fetchone()
    if user is None:
        return None
    conn.close()
    
    return constants.make_user_from_tuple(user)

def get_user_in_db(userid: str):
    conn = sqlite3.connect('credentials.db')
    c = conn.cursor()
    c.execute('SELECT * FROM credentials WHERE userid = ?', (userid,))
    
    user = c.fetchone()
    conn.close()
    
    return user

def user_exists(userid: str):
    conn = sqlite3.connect('credentials.db')
    c = conn.cursor()
    c.execute('SELECT * FROM credentials WHERE userid = ?', (userid,))
    
    user = c.fetchone()
    conn.close()
    
    return user is not None

def get_transaction_data_new(table_name: str, num_transactions: int = 10, offset: int = 0):
    conn = sqlite3.connect("credentials.db")
    c = conn.cursor()
    # c.execute(f"SELECT * FROM {username}_transactions LIMIT {num_transactions}, {offset}")
    c.execute(f"SELECT (id, merchant_name, merchant_id, address, phone_number, fax, invoice_number, gst_registration_number, gst_perctange, date, month, year, time, financial_document_class, item_type, total_amount, cashier_name, customer_name, number_of_items) FROM {table_name} LIMIT {offset}, {num_transactions}")
    data = c.fetchall()
    return transactions_processing.row_to_transaction(data)

def get_transaction_data(table_name: str, num_transactions: int = 1, offset: int = 0):
    conn = sqlite3.connect("credentials.db")
    c = conn.cursor()
    # c.execute(f"SELECT * FROM {username}_transactions LIMIT {num_transactions}, {offset}")
    c.execute(f"SELECT * FROM {table_name} ORDER BY id DESC LIMIT {offset}, {num_transactions}")
    data = c.fetchall()
    return data
    # return constants.construct_transaction_dataset(data)

def get_user_id(username: str):
    conn = sqlite3.connect("credentials.db")
    c = conn.cursor()
    c.execute("SELECT id FROM credentials WHERE userid = ?", (username,))
    user_id = c.fetchone()[0]
    conn.close()
    return user_id

def get_table_name(username: str):
    return f"transactions_{get_user_id(username)}"
    

def fetch_transactions(criteria):
    conn = sqlite3.connect('credentials.db')
    c = conn.cursor()
    query = 'SELECT * FROM transactions WHERE ' + ' AND '.join([f"{k} = ?" for k in criteria.keys()])
    c.execute(query, tuple(criteria.values()))
    return c.fetchall()


def insert_transaction_data_from_model(table_name: str, transaction_data: constants.TransactionData):
    # row_data = transactions_processing.transaction_to_row(transaction_data)
    conn = sqlite3.connect('credentials.db')
    c = conn.cursor()
    c.execute(f'''CREATE TABLE IF NOT EXISTS {table_name} (
    id INTEGER PRIMARY KEY,
    merchant_name TEXT,
    merchant_id TEXT,
    address TEXT,
    phone_number TEXT,
    fax TEXT,
    invoice_number TEXT,
    gst_registration_number TEXT,
    gst_percentage REAL,
    date TEXT,
    month TEXT,
    year INTEGER,
    time TEXT,
    financial_document_class TEXT,
    item_type TEXT,
    total_amount REAL,
    cashier_name TEXT,
    customer_name TEXT,
    number_of_items INTEGER
    )''')
    c.execute(f'''
    INSERT INTO {table_name} (merchant_name, merchant_id, address, phone_number, fax, invoice_number, gst_registration_number, gst_percentage, date, month, year, time, financial_document_class, item_type, total_amount, cashier_name, customer_name, number_of_items)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)''', (transaction_data.merchant_name, transaction_data.merchant_id, transaction_data.address, transaction_data.phone_number, transaction_data.fax, transaction_data.invoice_number, transaction_data.gst_registration_number, transaction_data.gst_percentage, transaction_data.date, transaction_data.month, transaction_data.year, transaction_data.time, transaction_data.financial_document_class, transaction_data.item_type, transaction_data.total_amount, transaction_data.cashier_name, transaction_data.customer_name, transaction_data.number_of_items))
    conn.commit()
    conn.close()
    




def insert_transaction(table_name, merchant_name, merchant_id, address, phone_number, fax, invoice_number, gst_registration_number, gst_percentage, date, month, year, time, financial_document_class, item_type, total_amount, cashier_name, customer_name, number_of_items):
    conn = sqlite3.connect('credentials.db')
    c= conn.cursor()
    c.execute(f'''CREATE TABLE IF NOT EXISTS {table_name} (
    id INTEGER PRIMARY KEY,
    merchant_name TEXT,
    merchant_id TEXT,
    address TEXT,
    phone_number TEXT,
    fax TEXT,
    invoice_number TEXT,
    gst_registration_number TEXT,
    gst_percentage REAL,
    date TEXT,
    month TEXT,
    year INTEGER,
    time TEXT,
    financial_document_class TEXT,
    item_type TEXT,
    total_amount REAL,
    cashier_name TEXT,
    customer_name TEXT,
    number_of_items INTEGER
    )''')
    print(table_name)
    c.execute(f'''
    INSERT INTO {table_name} (merchant_name, merchant_id, address, phone_number, fax, invoice_number, gst_registration_number, gst_percentage, date, month, year, time, financial_document_class, item_type, total_amount, cashier_name, customer_name, number_of_items)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''', (merchant_name, merchant_id, address, phone_number, fax, invoice_number, gst_registration_number, gst_percentage, date, month, year, time, financial_document_class, item_type, total_amount, cashier_name, customer_name, number_of_items))


    conn.commit()


def insert_transaction_data(table_name: str, transaction_data: constants.TransactionData):
    conn = sqlite3.connect("credentials.db")
    c = conn.cursor()
    # print(constants.deconstruct_transaction_data(transaction_data))
    c.execute(f'''CREATE TABLE IF NOT EXISTS {table_name} (
    id INTEGER PRIMARY KEY,
    merchant_name TEXT,
    merchant_id TEXT,
    address TEXT,
    phone_number TEXT,
    fax TEXT,
    invoice_number TEXT,
    gst_registration_number TEXT,
    gst_percentage REAL,
    date TEXT,
    month TEXT,
    year INTEGER,
    time TEXT,
    financial_document_class TEXT,
    item_type TEXT,
    total_amount REAL,
    cashier_name TEXT,
    customer_name TEXT,
    number_of_items INTEGER
    )''')
    c.execute(f"INSERT INTO {table_name} VALUES")
    # c.execute(f"INSERT INTO {table_name} VALUES (?, ?, ?, ?)", constants.deconstruct_transaction_data(transaction_data))
    conn.commit()
    c.execute(f"SELECT * FROM {table_name}")
    print(c.fetchall())
    conn.close()





