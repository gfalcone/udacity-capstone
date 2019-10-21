FROM python:3.7-buster

RUN pip install flask

COPY api.py /app/

WORKDIR /app

ENTRYPOINT ["python", "api.py"]