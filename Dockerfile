FROM python:3
ENV PYTHONUNBUFFERED 1
ENV DJANGO_SETTINGS_MODULE test.settings.build
RUN apt-get update
RUN apt-get install libtiff5-dev libjpeg62-turbo-dev libopenjp2-7-dev zlib1g-dev \
  libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python3-tk \
  libharfbuzz-dev libfribidi-dev libmagic1 -y

# Install Geo libraries (for geodjango)
RUN apt-get install binutils libproj-dev gdal-bin -y

RUN mkdir test
COPY requirements.txt /test/
RUN pip install -r /test/requirements.txt

COPY ./test/api /test/api
COPY ./test/catchall /test/catchall
COPY ./test/conf /test/conf
COPY ./test/cousteau /test/cousteau
COPY ./test/imagehandler /test/imagehandler
COPY ./test/airtablesync /test/airtablesync
COPY ./test/metrics /test/metrics
COPY ./test/comms /test/comms
COPY ./test/sepomex /test/sepomex
COPY ./test/holmes /test/holmes
COPY ./test/test /test/test
COPY ./test/website /test/website
COPY ./test/templates /test/templates
COPY ./test/internal-platform-260607-eac579f464e3.json /test/
COPY ./test/manage.py /test/manage.py
COPY ./test/frontend/build /test/frontend/build
COPY ./test/frontend/django /test/frontend/django
COPY ./test/notifier /test/notifier
COPY ./test/rawspaghetti /test/rawspaghetti
COPY ./test/utils /test/utils

WORKDIR /test
RUN python manage.py collectstatic --no-input
CMD gunicorn test.wsgi -b 0.0.0.0:8000