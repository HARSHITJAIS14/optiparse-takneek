import numpy as np
import pandas as pd
import json

#ocr part
from paddleocr import PaddleOCR,draw_ocr
import os
import cv2
import matplotlib.pyplot as plt
import matplotlib.image as img
import time
from PIL import Image
import pillow_avif

#llm part
import pathlib
import textwrap
import google.generativeai as genai
from IPython.display import display
from IPython.display import Markdown

import concurrent.futures
import google.generativeai as genai
from statistics import mode


def parsedData(text):
  api_keys = ['AIzaSyAX_cEktS58q2pVppSNo83alzIqczoU4y0', 'AIzaSyDwA7weNmViIgUFQJF4lPpcIK00qWAK-Y8', 'AIzaSyB0ZFA6L4ZTZizqfzVNOkItm8aPZsr4IGM','AIzaSyDR2gw0myt7q0e1YfBosv1Oleh3OkYMY0E','AIzaSyAdkJNmykW-8_voyFxNKNZoZTD9Bfuz72E','AIzaSyDCCZbPNuIL0FEKHiqc6Q_0wg8skTguOO8','AIzaSyB9KE97mvC_7z9NW0B_GNf9HKxUBT3si9U','AIzaSyDAvS3kAaobe-z0lx2A3k6QsyrrbL-1y00','AIzaSyBvM8J61_oBSwd-Lp8g5SgrgqUHEIxJo4E','AIzaSyCv-BBDffag0dImS3vzg1anUu3nInHp87g']
  api_index = [0]
  def call_gemini_api(model_name, prompt):
    while True:
      try:
        genai.configure(api_key=api_keys[api_index[0]])
        model = genai.GenerativeModel(model_name)
        response = model.generate_content(prompt)
        break
      except:
        api_index[0]=(api_index[0]+1)%10
        print(f"Now using {api_index[0]+1}th key")
    return response

  
  # Parallelize the API calls
  def run_models(text):
    with concurrent.futures.ThreadPoolExecutor(max_workers=3) as executor:
      futures = []
      prompt1 = '''Do not output NONE for any header. Given an input text corresponding to a financial document, we need to output a json file with the following 18 keys: Merchant Name, Merchant ID/code, Address of merchant, Phone number of merchant, email id of merchant, FAX of merchant, Invoice/Bill/Receipt number, GST Number, Identification Number, total GST percentage , Date of Transaction , Month of Transaction , Year of Transaction , Time of Transaction , Class of financial document , Type of item purchased , Total amount , Cashier name , Customer ID  , Customer name , Number of items \n While doing this, correct any spelling mistakes or issues arising due to OCR scanning. Note the following points-
  1) If no information is found for any of the fields, then take the closest information or generate the most likely output. Dont leave any output blank. \n
  2) identification numbers are likely to be large numbers or strings
  3) The total amount is likely to be the highest amount in the document.
  4. Replace all none and null values with field not tracked
  Following is the data: 
  : '''
      prompt2 = '''Do not output NONE for any header. You are provided with an input text that represents a financial document such as an invoice, bill, or receipt. Your task is to analyze this text and output a JSON file containing 18 specific keys with their corresponding values. Follow these instructions carefully:

  1. Extract the following details from the document and map them to the corresponding JSON keys:
  merchant_name
  merchant_id
  address
  phone_number
  fax
  invoice_number
  gst_registration_number
  gst_percentage
  date
  month
  year
  time
  string
  financial_document_class
  item_type
  total_amount
  cashier_name
  customer_name
  number_of_items
  2. Correct any spelling mistakes or errors resulting from OCR scanning. Ensure the extracted information is accurate and formatted correctly.
  3. For keys where information is missing or not explicitly stated, provide the closest possible information or generate a plausible value based on the context of the document.
  4. Special Considerations:
  - The Total amount is typically the highest numerical value listed in the document. Ensure this key is correctly identified and assigned.
  - The Date of Transaction, Month of Transaction, and Year of Transaction should be extracted or inferred from any date-related information present.
  - If any key does not apply or cannot be inferred, assign it a null value in the JSON.
  5. Output Format: Provide your final output in a JSON structure.
  6. Replace all none and null values with field not tracked'''

      prompt3= '''Task: Do not output NONE for any header. Extract financial information from a provided text document.

  Output Format: JSON object with the following keys:
  merchant_name
  merchant_id
  address
  phone_number
  fax
  invoice_number
  gst_registration_number
  gst_percentage
  date
  month
  year
  time
  string
  financial_document_class
  item_type
  total_amount
  cashier_name
  customer_name
  number_of_items
  1. OCR Error Correction: If necessary, correct any OCR errors in the input text.
  2. Information Extraction: Extract the specified information from the text.
  3. Missing Information: If any key cannot be directly extracted, use context clues or generate a plausible value based on the document type and other available information.
  4. Total Amount: Assume the highest numerical value in the document is the total amount unless there are strong indicators otherwise.
  5. Replace all none and null values with field not tracked
  '''
      prompts = [prompt1, prompt2,prompt3]
      for prompt in prompts:
        query = prompt+ text
        futures.append(executor.submit(call_gemini_api, 'models/gemini-1.5-flash', query ))
        results = [future.result() for future in concurrent.futures.as_completed(futures)]
    return results

  rac = run_models(text)
  #print(rac[0].text.split('```'))
  jsonOutputs_list = [json.loads(i.text.split('```')[1].split('json')[1]) for i in rac]
  print(jsonOutputs_list)
  def compute_mode_dict(list_of_dicts):
    key_values = {key: [] for key in list_of_dicts[0]}
    
    for d in list_of_dicts:
        for key, value in d.items():
          try:
            key_values[key].append(value)
          except:
            pass
    
    mode_dict = {key: mode([str(i) for i in values]) for key, values in key_values.items()}    
    return mode_dict

  cute_raccoon = compute_mode_dict(jsonOutputs_list)
  #print(type(jsonOutputs_list))
  #print(jsonOutputs_list)
  return cute_raccoon