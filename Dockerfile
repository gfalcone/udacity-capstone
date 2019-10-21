FROM python:3.7-buster

RUN pip install flask==1.1.1

COPY api.py /app/

WORKDIR /app

ENTRYPOINT ["python", "api.py"]