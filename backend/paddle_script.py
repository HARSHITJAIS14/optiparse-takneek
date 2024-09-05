import numpy as np
import pandas as pd

#ocr part
from paddleocr import PaddleOCR,draw_ocr
import os
import cv2
import matplotlib.pyplot as plt
import matplotlib.image as img
import time
from PIL import Image
import pillow_avif
import pathlib
from PIL import Image
import os

ocr = PaddleOCR(use_angle_cls=True, lang='en', use_gpu=False) # need to run only once to download and load model into memory


def func_alt(img_data):
    res = ocr.ocr(img_data, cls=True)
    
    
    if res is not None:
      res = res[0]
      extracted_text=''
      for i in res:
        extracted_text+=f' {i[1][0]}'
      res = extracted_text
    return res
   

def func(img_path):
    if img_path.endswith(('.png', '.jpeg', '.bmp', '.gif', '.tiff', '.avif')): 
        img = Image.open(img_path)
        new_filename = img_path.split("/")[-1].split(".")[0] + '.jpg'
        output_dir = "./"								#Set acc to the server
        filePath=output_dir+new_filename
        img.save(filePath)
    else:
        filePath = img_path
    res = ocr.ocr(filePath, cls=True)
    
    if res is not None:
      res = res[0]
      extracted_text=''
      for i in res:
        extracted_text+=f' {i[1][0]}'
      res = extracted_text
    return res
