

# Financial Data Extraction App

## 1. OCR Model: PaddleOCR

For this project, the **PaddleOCR** model was chosen due to its balance of accuracy and performance. Previous attempts with **Tesseract** and **EasyOCR** had limitations—**Tesseract** showed low accuracy, and **EasyOCR** suffered from high inference times, making it unsuitable for real-time applications.

### PaddleOCR Overview

- **PaddleOCR** is a lightweight, efficient OCR model built on the PaddlePaddle deep learning framework.
- It supports over 80 languages, but for this project, English (`lang='en'`) was used.
- **Angle Classification** (`use_angle_cls=True`) was enabled to improve accuracy when dealing with rotated or skewed text.

### 1. Image Format Conversion

The first step of the process involves handling images that may not be directly supported by the OCR model. The system checks whether the image is in any of the following formats:
- `.png`
- `.jpeg`
- `.bmp`
- `.gif`
- `.tiff`
- `.avif`

If the image is in one of these formats, it is converted to `.jpg` to ensure compatibility with **PaddleOCR**. The conversion is handled by the **Pillow** library, and the converted image is saved locally.

### 2. Feeding the Image to the OCR Model

After format conversion (if necessary), the image is passed to the **PaddleOCR** model for text extraction. The model processes the image, accounting for potential angle variations using `use_angle_cls=True`, and returns structured data.

### 3. Extracting and Storing Text

From the structured OCR output, which includes bounding boxes, confidence scores, and recognized text:
- Only the extracted text is retained.
- The recognized text is concatenated into a **single string**.

This string serves as the final processed text from the image, which can be used for downstream tasks or passed to the next part of the architecture.

## 2. Feeding Extracted Data to LLMs

Once the text has been extracted via **PaddleOCR**, it is passed to multiple Large Language Models (LLMs) for further processing. The objective is to utilize the strength of multiple prompts and models to ensure higher accuracy.

### Approach Overview

1. **Extracted Data**: The OCR-extracted text is passed to three different prompts of an LLM (in this case, **Gemini 1.5 Flash**, provided free by Google).
   
2. **Prompt Execution**: Each of the three prompts processes the same data point, and their predictions are gathered.

3. **Mode Calculation**: To ensure the highest accuracy, the **mode** (most frequent prediction) is calculated from the outputs of the three prompts for each data point. This method minimizes errors from any single prompt.

4. **Final Output**: The final results are consolidated and stored in a **JSON** format, which is then passed to the backend for further use.

## 3. Backend Integration

We developed a **Flutter** app that captures images of transaction bills and extracts the relevant financial fields.

### Image Capturing

- The app includes a user-specific image capture feature.
- After a successful login, the user is presented with two options: 
  1. To capture a new transaction bill image.
  2. To use saved images from local files.

### OCR and LLM Processing

- The captured image is sent from the frontend to the OCR model, which processes the image and returns the extracted text.
- This text data is then passed to the LLM, which processes it to return relevant financial data points. 
- The LLM's output consists of 18 key fields in **JSON** format, which is sent back to the application.

### Transaction Details

- The JSON data is presented in a table format displaying all 18 keys.
- A **search option** is available for users to navigate through specific data points easily.


## The backend documentation can be found at the link [here](https://backend-optiparse-takneek24-2.onrender.com/docs)
## https://backend-optiparse-takneek24-2.onrender.com/docs
