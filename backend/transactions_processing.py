import sqlite3
from pydantic import BaseModel
import constants
# Pydantic model for a transaction
class Transaction(BaseModel):
    id: int
    merchant_name: str
    merchant_id: str
    address: str
    phone_number: str
    fax: str
    invoice_number: str
    gst_registration_number: str
    gst_percentage: float
    date: str
    month: str
    year: int
    time: str
    financial_document_class: str
    item_type: str
    total_amount: float
    cashier_name: str
    customer_name: str
    number_of_items: int

# Function to convert a row from the database to a Transaction object
def row_to_transaction(row):
    return constants.TransactionData(
        merchant_name=row[1],
        merchant_id=row[2],
        address=row[3],
        phone_number=row[4],
        fax=row[5],
        invoice_number=row[6],
        gst_registration_number=row[7],
        gst_percentage=row[8],
        date=row[9],
        month=row[10],
        year=row[11],
        time=row[12],
        financial_document_class=row[13],
        item_type=row[14],
        total_amount=row[15],
        cashier_name=row[16],
        customer_name=row[17],
        number_of_items=row[18]
    )

# Function to convert a Transaction object to a row for the database
def transaction_to_row(transaction: constants.TransactionData):
    return (
        transaction.merchant_name,
        transaction.merchant_id,
        transaction.address,
        transaction.phone_number,
        transaction.fax,
        transaction.invoice_number,
        transaction.gst_registration_number,
        transaction.gst_percentage,
        transaction.date,
        transaction.month,
        transaction.year,
        transaction.time,
        transaction.financial_document_class,
        transaction.item_type,
        transaction.total_amount,
        transaction.cashier_name,
        transaction.customer_name,
        transaction.number_of_items
    )
# Connect to SQLite database (or create it if it doesn't exist)
# conn = sqlite3.connect('transactions.db')
# cursor = conn.cursor()

# Create the transactions table
# cursor.execute('''
# CREATE TABLE IF NOT EXISTS transactions (
#     id INTEGER PRIMARY KEY,
#     merchant_name TEXT,
#     merchant_id TEXT,
#     address TEXT,
#     phone_number TEXT,
#     fax TEXT,
#     invoice_number TEXT,
#     gst_registration_number TEXT,
#     gst_percentage REAL,
#     date TEXT,
#     month TEXT,
#     year INTEGER,
#     time TEXT,
#     financial_document_class TEXT,
#     item_type TEXT,
#     total_amount REAL,
#     cashier_name TEXT,
#     customer_name TEXT,
#     number_of_items INTEGER
# )
# ''')
# conn.commit()

# Function to insert a new transaction
def insert_transaction(table_name, merchant_name, merchant_id, address, phone_number, fax, invoice_number, gst_registration_number, gst_percentage, date, month, year, time, financial_document_class, item_type, total_amount, cashier_name, customer_name, number_of_items):
    cursor.execute('''
    INSERT INTO transactions (merchant_name, merchant_id, address, phone_number, fax, invoice_number, gst_registration_number, gst_percentage, date, month, year, time, financial_document_class, item_type, total_amount, cashier_name, customer_name, number_of_items)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''', (merchant_name, merchant_id, address, phone_number, fax, invoice_number, gst_registration_number, gst_percentage, date, month, year, time, financial_document_class, item_type, total_amount, cashier_name, customer_name, number_of_items))
    conn.commit()

# Function to fetch transactions based on criteria
def fetch_transactions(criteria):
    query = 'SELECT * FROM transactions WHERE ' + ' AND '.join([f"{k} = ?" for k in criteria.keys()])
    cursor.execute(query, tuple(criteria.values()))
    return cursor.fetchall()

# Example usage
# insert_transaction('Merchant A', 'M123', '123 Street', '1234567890', '0987654321', 'INV001', 'GST123', 18.0, '2023-10-01', 'October', 2023, '12:00', 'Invoice', 'Electronics', 1000.0, 'Cashier A', 'Customer A', 5)
# transactions = fetch_transactions({'merchant_name': 'Merchant A', 'year': 2023})
# for transaction in transactions:
#     print(transaction)

# # Close the connection
# conn.close()