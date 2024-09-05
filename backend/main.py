from typing import Annotated
from pydantic import BaseModel
from passlib.context import CryptContext

from fastapi import Depends, FastAPI, HTTPException, status, File, UploadFile
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm

import jwt
from datetime import datetime, timedelta, timezone

# import query_processing
import credentials
import constants
# import paddle_script
import ocr
import llm
import llm_2
import os
import shutil
import db_setup


db_setup.create_db()
app = FastAPI()



oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

pwd_context = CryptContext(schemes=["md5_crypt"], deprecated="auto")


# password hashing functions

def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)
def get_password_hash(password):
    return pwd_context.hash(password)

# token generation and decoding functions

def decode_token(jwt_token: str):
    try:
        payload = jwt.decode(jwt_token, constants.SECRET_KEY, algorithms=[constants.ALGORITHM])
        print("Payload type:", type(payload), payload)
        username: str = payload.get("username")
        if credentials.get_user(username):
            return credentials.get_user(username)
        else:
            return "User does not exist"
    except jwt.ExpiredSignatureError:
        return "Signature has expired"
    except jwt.InvalidTokenError:
        return "Invalid token"
    

def generate_token(username: str, expire_time: int = constants.ACCESS_TOKEN_EXPIRE_MINUTES):
    data_dict = {"username": username}
    expire_time = datetime.now() + timedelta(minutes=expire_time)
    data_dict.update({"exp": expire_time})
    jwt_token = jwt.encode(data_dict, constants.SECRET_KEY, algorithm=constants.ALGORITHM)

    return jwt_token

@app.get("/")
async def root():
    return {"message": "Hello Ravi's World"}


@app.post("/signup")
async def signup(username: str, password: str):
    # should the password received be hashed or unhashed?
    print("Password hash:", get_password_hash(password))
    if(credentials.user_exists(username)):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="User already exists",
        )

       
    credentials.signup(username, get_password_hash(password))
    return {"message": "User created"}
    


@app.get("/user")
async def get_current_user(token: Annotated[str, Depends(oauth2_scheme)]):
    user = decode_token(token)
    if type(user) == str:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=user,
            headers={"WWW-Authenticate": "Bearer"},
        )
    return {"username": user.username, "email": user.email, "account_number": user.account_number, "aadhar_number": user.aadhar_number, "pan_number": user.pan_number, "phone_number": user.phone_number}

@app.post("/token")
async def login(form_data: Annotated[OAuth2PasswordRequestForm, Depends()]):
    print("In here")
    user = credentials.get_user(form_data.username)
    print(user)
    if user == None:
        raise HTTPException(
            status_code=400, detail="Incorrect username or password"
        )
    if not verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=400, detail="Incorrect username or password"
        )
    print(type(user))
    token = generate_token(user.username, 30)
    return {"access_token": token, "token_type": "bearer"}

@app.post("/logout")
async def logout(token: Annotated[str, Depends(oauth2_scheme)]):
    return {"message": "Logged out"}

@app.post("/update_details")
async def update_details(token: Annotated[str, Depends(oauth2_scheme)], account_number: str, email: str, phone_number: str = "", pan_number: str = "", aadhar_number: str = ""):
    user = decode_token(token)
    if type(user) == str:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=user,
            headers={"WWW-Authenticate": "Bearer"},
        )
    credentials.update_users(userid=user.username, pan_number=pan_number,account_number=account_number, phone_number=phone_number, aadhar_number=aadhar_number, email_id=email)

    return {"message": "Update details"}

@app.post("/query")
async def query_alt(token: Annotated[str, Depends(oauth2_scheme)] ,file: UploadFile | None = None):
    user = decode_token(token)
    if type(user) == str:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=user,
            headers={"WWW-Authenticate": "Bearer"},
        )
    if file == None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No file sent",
        )
    # if file.content_type != "image/jpeg":
    #     raise HTTPException(
    #         status_code=status.HTTP_400_BAD_REQUEST,
    #         detail="Only jpeg files are supported",
    #     )
    file_location = f"files/{file.filename}"  # Define the path where you want to save the file

    # Ensure the directory exists
    os.makedirs(os.path.dirname(file_location), exist_ok=True)

    # Save the uploaded file to disk
    with open(file_location, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
    print(file.filename)
    # return paddle_script.func(file_location)
    json_obj = llm_2.parsedData(ocr.img_to_txt(file_location))
    credentials.insert_transaction_data_from_model(user.table_name, constants.json_obj_to_user(json_obj))
    if os.path.exists(file_location):
        os.remove(file_location)
    return json_obj

# @app.post("/query")
# async def query_alt(token: Annotated[str, Depends(oauth2_scheme)] ,file: UploadFile | None = None):
#     user = decode_token(token)
#     if type(user) == str:
#         raise HTTPException(
#             status_code=status.HTTP_401_UNAUTHORIZED,
#             detail=user,
#             headers={"WWW-Authenticate": "Bearer"},
#         )
#     if file == None:
#         raise HTTPException(
#             status_code=status.HTTP_400_BAD_REQUEST,
#             detail="No file sent",
#         )
#     # if file.content_type != "image/jpeg":
#     #     raise HTTPException(
#     #         status_code=status.HTTP_400_BAD_REQUEST,
#     #         detail="Only jpeg files are supported",
#     #     )
#     file_location = f"files/{file.filename}"  # Define the path where you want to save the file

#     # Ensure the directory exists
#     os.makedirs(os.path.dirname(file_location), exist_ok=True)

#     # Save the uploaded file to disk
#     with open(file_location, "wb") as buffer:
#         shutil.copyfileobj(file.file, buffer)
#     print(file.filename)
#     # return paddle_script.func(file_location)
#     json_obj = llm.parsedData(ocr.img_to_txt(file_location))
#     credentials.insert_transaction_data_from_model(user.table_name, constants.json_obj_to_user(json_obj))
#     if os.path.exists(file_location):
#         os.remove(file_location)
#     return json_obj
    # return llm.parsedData(ocr.img_to_txt(file_location))
    # return query_processing.process_image(file.file)

@app.post("/insert_data")
async def insert_data(token: Annotated[str, Depends(oauth2_scheme)], transaction_data: constants.TransactionData):
    user = decode_token(token)
    if type(user) == str:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail = user,
            headers = {"WWW-Authenticate": "Bearer"},
        )
    credentials.insert_transaction_data_from_model(user.table_name, transaction_data)
    return {"message": "Data inserted successfully"}
    
    
@app.post("/transaction_data")
async def get_transaction_data(token: Annotated[str, Depends(oauth2_scheme)], num_transactions: int = 10, offset: int = 0):
    user = decode_token(token)
    if type(user) == str:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=user,
            headers={"WWW-Authenticate": "Bearer"},
        )
    return credentials.get_transaction_data(user.table_name, num_transactions=num_transactions, offset=offset)


    

    

