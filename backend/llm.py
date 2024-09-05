import os
from azure.ai.inference import ChatCompletionsClient
from azure.ai.inference.models import SystemMessage, UserMessage
from azure.core.credentials import AzureKeyCredential
from dotenv import load_dotenv
import json

load_dotenv()

endpoint = "https://models.inference.ai.azure.com"
model_name = "gpt-4o"
token = os.environ["GITHUB_TOKEN"]

client = ChatCompletionsClient(
    endpoint=endpoint,
    credential=AzureKeyCredential(token),
)

def parsedData(txt:str):
    msg_content = f"""
Below is an image-to-text conversion of a bill receipt. Your task is to return structured data in JSON format as per the structure provided below. Ensure the JSON fields follow the specified format. If any field is missing from the image data, assign it a value of `"NA"`. Do not include any other information or explanation, only the JSON data. And also try to make spelling corrects.   
Dont give me markdown output, give only json output.    
Structured data format example:

``` 
  "merchant_name": "string",
  "merchant_id": "string",
  "address": "string",
  "phone_number": "string",
  "fax": "string",
  "invoice_number": "string",
  "gst_registration_number": "string",
  "gst_percentage": 0,
  "date": "string",
  "month": "string",
  "year": 0,
  "time": "string",
  "financial_document_class": "string",
  "item_type": "string",
  "total_amount": 0,
  "cashier_name": "string",
  "customer_name": "string",
  "number_of_items": 0
```

Below is the data extracted from the image:
```
{txt}
```
Give me only the json data as a string which I can use to parse json, no backticks or anything.
"""

    response = client.complete(
        messages=[
            SystemMessage(content="You are a helpful assistant."),
            UserMessage(content=msg_content),
        ],
        model=model_name,
        temperature=1.,
        max_tokens=1000,
        top_p=1.
    )
    print(response.choices[0].message.content)
    return json.loads(response.choices[0].message.content)