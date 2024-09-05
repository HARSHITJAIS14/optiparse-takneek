import numpy as np
import pandas as pd

#ocr part
from paddleocr import PaddleOCR
from PIL import Image
from PIL import Image

ocr = PaddleOCR(use_angle_cls=True, lang='en') # need to run only once to download and load model into memory


def img_to_txt(img_path):
    if img_path.endswith(('.png', '.jpeg', '.bmp', '.gif', '.tiff', '.avif')): 
        img = Image.open(img_path)
        new_filename = img_path.split("/")[-1].split(".")[0] + '.jpg'
        output_dir = "./"								#Set acc to the server
        filePath=output_dir+new_filename
        img.save(filePath)
    else:
        filePath = img_path
    res = ocr.ocr(filePath, cls=True)
    img = Image.open(filePath)
    if res is not None:
      res = res[0]
      extracted_text=''
      for i in res:
        extracted_text+=f' {i[1][0]}'
      res = extracted_text
    return res
