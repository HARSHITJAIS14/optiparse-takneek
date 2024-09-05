import google.generativeai as genai
# import PIL.Image
import os
# import pytesseract

import constants
import paddle_script

import time




query_template = """
This is some financial transactions data, create a table of transactions with each column headings, which are transaction recipient/sender, transaction amount, and anything else goes in additional remarks:\n
"""
#  FINANCE BANK
#  0987 Second Street; Austin, TX 12345-6789
#  1-000-222-3456
#  Photography Business, LLC
#  Account Name:
#  Photography Business, LLC
#  Mr. Bean Lasso
#  Account Number: 0000000098765
#  123 Abraham Street
#  Account Type:
#  Checking
#  Austin
#  Tx 12345-6789
#  Statement Period: 06/01/2022 to 06/30/2022
#  111-222-3333
#  ACCOUNT SUMMARY
#  Balance on June
#  S34,572.23
#  Total money in:
#  S12,193.75
#  Total money out:
#  $ 9,254.52
#  Balance on June 30:
#  537,511.46
#  DATE
#  DESCRIPTION
#  WITHDRAWAL
#  DEPOSIT
#  BALANCE
#  Previous Balance
#  34,572.23
#  06/01
#  Rent Bill
#  670.00
#  33,902.23
#  Check No. 3456
#  06/03
#  740.00
#  34,642.23
#  Payment from Nala Spencer
#  06/08
#  Electric Bill
#  347.85
#  34,294.38
#  06/13
#  Phone Bill
#  75.45
#  34,218.93
#  06/15
#  Deposit
#  7,245.00
#  41,463.93
#  Debit Transaction
#  06/18
#  339.96
#  41,123.97
#  Photography Tools Warehouse
#  06/24
#  Deposit
#  3,255.00
#  44,378.97
#  6/25
#  Internet Bill
#  88.88
#  44,290.09
#  Check No. 0231
#  16/28
#  935.00
#  45,225.09
#  Payment from Kyubi Tayler
#  6/29
#  Payroll Run
#  6,493.65
#  38,731.44
#  Debit Transaction
#  6/30
#  1,234.98
#  37,496.46
#  Picture Perfect Equipments
#  730
#  Interest Earned
#  18.75
#  37,515.21
#  06/30
#  Withholding Tax
#  3.75
#  37,511.46
#  Ending Balance
#  37,511.46
#  FINANCE
#  StRategists
#  City,


genai.configure(api_key=constants.GOOGLE_API_KEY)
# pytesseract.pytesseract.tesseract_cmd = constants.TESSERACT_PATH
# genai.configure(api_key=os.environ["GOOGLE_API_KEY"])
def get_query(prompt: str):
    model = genai.GenerativeModel(model_name="gemini-1.5-flash")
    response = model.generate_content([prompt])
    return response.text


def process_image(image_file):
    # image = PIL.Image.open(image_file)

    # query_data = pytesseract.image_to_string(image)
    
    
    # query_data = paddle_script.func()
    # print("OCR Output:", query_data)
    # return get_query(query_template + query_data)
    return {"Hello"}



if __name__ == "__main__":
    if constants.TIME_DEBUGGING:
        time1 = time.time()
    print(get_query(query))

    if constants.TIME_DEBUGGING:
        time2 = time.time()
        print("Time taken:", time2 - time1)

