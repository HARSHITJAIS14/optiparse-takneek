FROM python:3
RUN apt-get update
# RUN apt-get -y install tesseract-ocr libtesseract-dev
WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY . .
RUN python3 db_setup.py
EXPOSE 8060/tcp
EXPOSE 8060/udp
ENTRYPOINT [ "fastapi","run","main.py","--port","8060"]
# ENTRYPOINT [ "fastapi","dev" ]
