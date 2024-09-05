from pydantic import BaseModel

class Token(BaseModel):
    access_token: str
    token_type: str

class User(BaseModel):
    username: str
    hashed_password: str
    account_number: str | None = None
    email_id: str | None = None
    pan_number: str | None = None
    aadhar_number: str | None = None
    phone_number: str | None = None
    email: str | None = None
    table_name: str
    

def make_user_from_tuple(user: tuple): # make class from database query tuple
    print("user is:", user)
    return User(table_name = f"transactions_{user[0]}" ,username=user[1], hashed_password=user[2], account_number=user[3], email=user[4], pan_number=user[5], aadhar_number=user[6], phone_number=user[7])
    # return User(username=user[0], hashed_password=user[1],table_name=user[0], disabled=False)

# debugging markers
TIME_DEBUGGING = True

# tesseract file path
TESSERACT_PATH = r'/usr/bin/tesseract'

# google api key
GOOGLE_API_KEY = "AIzaSyDrS8WHH99ToAPqgR_YvcwXyTrdP98yRoA"

# secret key used to sign the JWT tokens
SECRET_KEY = "77df9607cc288390b0cf0872b1121dd2e30614ba03d843546400c6a3a7ee20ea" # openssl rand -hex 32
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

AUTH_DATABASE_FILENAME = "credentials.db"
AUTH_TABLE_NAME = "credentials"
# AUTH_TABLE_SCHEMA = "CREATE TABLE IF NOT EXISTS credentials (id integer primary key AUTOINCREMENT, userid TEXT, password TEXT, account_number TEXT, email_id TEXT, table_name TEXT)"
AUTH_TABLE_SCHEMA = "CREATE TABLE IF NOT EXISTS credentials (id INTEGER PRIMARY KEY AUTOINCREMENT, userid TEXT, password TEXT, account_number TEXT, email_id TEXT, table_name TEXT, pan_number TEXT, aadhar_number TEXT, phone_number TEXT)"
AUTH_TABLE_INSERT = "INSERT INTO credentials (userid, password, account_number, email_id, table_name, pan_number, aadhar_number, phone_number) VALUES (?, ?, NULL, NULL, NULL, NULL, NULL, NULL)"

GET_ID_QUERY = "SELECT (id) FROM credentials WHERE userid = ?"

DATAPOINTS = {
    "merchant_name": "TEXT",
    "merchant_id": "TEXT",
    "transaction_date": "TEXT",
    "address_merchant": "TEXT",
    "phone_number_merchant": "TEXT",
    "invoice_number": "TEXT", # invoice bill and receipt
    "gst_reg_number": "TEXT",
    "gst_percentage": "REAL",
    "transaction_amount": "REAL",
    "transaction_description": "TEXT",
    "transaction_details": "TEXT",
    "type_of_item": "TEXT",
    "cashier": "TEXT",
    "number_of_items": "INTEGER",
    
}



# class TransactionData(BaseModel):
#     transaction_date: str
#     transaction_description: str
#     transaction_amount: str
#     transaction_details: str

class TransactionData(BaseModel):
    merchant_name: str = "N/A"
    merchant_id: str = "N/A"
    address: str = "N/A"
    phone_number: str = "N/A"
    fax: str = "N/A"
    invoice_number: str = "N/A"
    gst_registration_number: str = "N/A"
    gst_percentage: str = "N/A"
    date: str = "N/A"
    month: str = "N/A"
    year: str = "N/A"
    time: str= "N/A"
    financial_document_class: str= "N/A"
    item_type: str = "N/A"
    total_amount: str = "N/A"
    cashier_name: str = "N/A"
    customer_name: str = "N/A"
    number_of_items: str = "N/A"

class TransactionDataset(BaseModel):
    transactions: list[TransactionData]
    

def create_transaction_table_query(userid):
    # string_appended = ""
    # for i in DATAPOINTS:
    #     string_appended += f"{i} {DATAPOINTS[i]}, "
    # string_appended = string_appended[:-2]
    # return f"CREATE TABLE IF NOT EXISTS transactions_{userid} ({string_appended})"
    return f'''CREATE TABLE IF NOT EXISTS transactions_{userid} (
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
    )'''
    # return f"CREATE TABLE IF NOT EXISTS transactions_{userid} ({string_appended})"



all_keys = [
    "merchant_name",
    "merchant_id"
    "address",
    "phone_number",
    "fax",
    "invoice_number",
    "gst_registration_number",
    "gst_percentage",
    "date",
    "month",
    "year",
    "time",
    "financial_document_class",
    "item_type",
    "total_amount",
    "cashier_name",
    "customer_name",
    "number_of_items"

]
def json_obj_to_user(obj):
    for i in all_keys:
        if i not in obj:
            obj[i] = "N/A"
    return TransactionData(merchant_name=str(obj["merchant_name"]),
                    merchant_id=str(obj["merchant_id"]), 
                    address=str(obj["address"]),
                    invoice_number=str(obj["invoice_number"]),
                    gst_registration_number=str(obj["gst_registration_number"]),
                    gst_percentage=str(obj["gst_percentage"]),
                    date=str(obj["date"]),
                    month=str(obj["month"]),
                    year=str(obj["year"]),
                    time=str(obj["time"]),
                    financial_document_class=str(obj["financial_document_class"]),
                    item_type=str(obj["item_type"]),
                    total_amount=str(obj["total_amount"]),
                    cashier_name=str(obj["cashier_name"]),
                    customer_name=str(obj["customer_name"]),
                    number_of_items=str(obj["number_of_items"]),
                    )


    
    

    return TransactionData()


def create_transaction_insert_query(username):
    return f"INSERT INTO {username}_transactions VALUES (?, ?, ?, ?)"



def deconstruct_transaction_data(transaction_data: TransactionData):
    return (transaction_data.transaction_date, transaction_data.transaction_description, transaction_data.transaction_amount, transaction_data.transaction_details)

def construct_transaction_data(transaction_row: list):
    return TransactionData(transaction_date=transaction_row[0], transaction_description = transaction_row[1], transaction_amount = transaction_row[2], transaction_details = transaction_row[3])

def construct_transaction_dataset(query_rows: list):
    transaction_data_list = []
    for i in query_rows:
        transaction_data_list.append(construct_transaction_data(i))
    transaction_dataset = TransactionDataset(transactions = transaction_data_list)
    return transaction_dataset
    
    

TRANSACTION_DATABASE_FILENAME = "transactions.db"



