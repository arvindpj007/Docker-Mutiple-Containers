FROM python:3.7-alpine
RUN apk update && apk add postgresql-dev gcc python3-dev musl-dev
RUN mkdir /app
COPY . /app/
WORKDIR /app
RUN pip install -r requirements.txt
EXPOSE 5000
ENV FLASK_APP=main.py
CMD flask run --host=0.0.0.0 -p 8080

