# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.8-alpine3.11
EXPOSE 8000
# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1
# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1
# Install pip requirements
ADD requirements.txt .
RUN apk add --update --no-cache postgresql-client jpeg-dev
RUN apk add --update --no-cache --virtual .tmp-build-deps \
    gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev
RUN python -m pip install -r requirements.txt
RUN apk del .tmp-build-deps
WORKDIR /app
ADD ./app /app
# For more secure we add these two lines below
RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static
RUN adduser -D user
RUN chown -R user:user /vol/
RUN chmod -R 755 /vol/web
USER user
# During debugging, this entry point will be overridden. For more information, refer to https://aka.ms/vscode-docker-python-debug
# File wsgi.py was not found in subfolder:recipe-api-app. Please enter the Python path to wsgi file.
#CMD ["gunicorn", "--bind", "0.0.0.0:8000", "pythonPath.to.wsgi"]
