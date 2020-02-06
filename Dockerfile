FROM python:3.7-alpine
LABEL Author="Brian Alexander" 

# Recommended for running python in a docker container
ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt
RUN apk add --update --no-cache postgresql-client

# Install build requirements for psycopg2
RUN apk add --update --no-cache --virtual .tmp-build-deps \
    gcc libc-dev linux-headers  postgresql-dev

RUN pip install -r /requirements.txt

# Remove build requirements for psycopg2
RUN apk del .tmp-build-deps

RUN mkdir /app
WORKDIR /app
COPY ./app /app

# -D means create a user for only running applications (here username is 'user')
# Switch to the new user
# Used to avoid running as root
RUN adduser -D user
USER user