FROM python:3.11-slim

WORKDIR /usr/src/app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y netcat-openbsd && apt-get clean

RUN pip install --upgrade pip
COPY ./requirements.txt .
RUN pip install -r requirements.txt

COPY ./ent.sh .
RUN sed -i 's/\r$//g' /usr/src/app/ent.sh
RUN chmod +x /usr/src/app/ent.sh

COPY . .
ENTRYPOINT ["/usr/src/app/ent.sh"]
CMD ["gunicorn", "backend.wsgi:application", "--bind", "0.0.0.0:8000"]