import llm
import ocr
import json

raw_data = ocr.img_to_txt("img.jpg")
print(raw_data)
act = llm.parsedData(raw_data)
print(act)
print(json.loads(act))  