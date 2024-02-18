# Puffy

## Prerequisites

- Python3
- Postgres (Postgres.app recommended for mac)
- NodeJS (Frontend)

## WDEC

Wdec is a dockerized development environment for Watson, it's an easier and production-like way for development enviroment installation. Please refer to the repo for installation intructions: https://github.com/FlatDigital/wdec

If you prefer to go for a local installation and manually install the requirements you can find a really helpful guide in the next section "Local setup"

## Local setup

```
python3 -m venv vendor
source vendor/bin/activate
pip install -r requirements.txt
```

It's likely you'll need to install additional libraries:

```
brew install libmagic
```

For GeoDjango, some libraries must be installed. See: https://docs.djangoproject.com/en/3.0/ref/contrib/gis/install/#macos

```
brew install gdal
```

For Postgis, perform

```
brew install postgis
```

In order to be able to create properties, you'll need to create some zip.
Easiest way is to download postico and enter the sepomex_sepomexadress table.

Now, save the required env vars in a file (we suggest something like `vars.env`) and run it (`source vars.env`) every time you work on this project.
It's also suggested you create a `test/settings/local.py` file for local development. You can copy it from `test/settings/local.py.template`

```
# Sample vars.env
export POSTGRESQL_HOST=localhost
export POSTGRESQL_USER=myuser
export POSTGRESQL_DB_NAME=mydb
export POSTGRESQL_PASSWORD=12345 # please don't use this as a password
export DJANGO_ENV=DEV
export AIRTABLE_API_KEY=myairtablekey
export GOOGLE_LOGIN_CLIENT_ID=testtest.apps.googleusercontent.com
export GOOGLE_LOGIN_SECRET_KEY=mysecretkey
export DJANGO_SETTINGS_MODULE=test.settings.local
export GCAL_WEBHOOK_URL=https://localhost:8000 # Test setting, requires https
export SLACK_TOKEN=some_slack_bot_app_token
export HUBSPOT_API_KEY=myhubspotkey
```
Note: Replacement of the demo values for ```GOOGLE_LOGIN_CLIENT_ID```, ```GOOGLE_LOGIN_SECRET_KEY``` is required in order to allow authentication

You'll also have to create a superuser

```
source vars.env
python manage.py migrate
python manage.py createsuperuser
```
For the project to run successfully you must be running postgresql. To check wether it's running (In Ubuntu 20.04, this may differ depending on OS):

```
service postgresql status
```
To start the server (In Ubuntu 20.04, this may differ depending on OS): 
```
sudo service postgresql start
```

To check values of environment variables: 
```
printenv
```

We use sass as our css pre-processor. When developing, use the following command to compile css after saving. Inside test:
```
sass --watch website/static/scss/custom.scss:website/static/css/custom.min.css
```

For frontend development using livereload may speed up the process. We are using django live reload server. 
[Djando Live Reload Server](https://github.com/tjwalch/django-livereload-server)
To start the django live reload plugin
in internal first run (if it isn't already running):
```
source vendor/bin/activate
source vars.env
```
then, inside test:
``` 
python manage.py livereload
```


For day to day development these are the three commands you must use:
```
source vendor/bin/activate
source vars.env
python test/manage.py runserver
```

[Vscode](https://code.visualstudio.com/) is our default, preferred code editor.
Here are some useful settings:
```
{
  "editor.tabSize": 4,
  "editor.rulers": [
      80
  ],
  "editor.tabCompletion": "on",
  "breadcrumbs.enabled": true,
  "editor.formatOnPaste": true,
  "editor.formatOnSave": true,
  "editor.formatOnType": true,
  "python.linting.pylintEnabled": false,
  "python.linting.flake8Enabled": true,
  "workbench.editor.highlightModifiedTabs": true,
  "python.autoComplete.addBrackets": true,
  "editor.detectIndentation": true,
  "html.format.wrapLineLength": 0,
  "html.format.wrapAttributes": "force-aligned",
  "diffEditor.ignoreTrimWhitespace": false,
  "scssFormatter.printWidth": 80,
}
```

We use `autopep8` as formatter, and `flake8` as linter for python.
We use VSCode's default formatter for HTML, CSS and SCSS.

Since we're running a hybrid of a Django app + SPA, whenever we go into the SPA, we proxy the request to node's dev build. So, everytime you run `python manage.py runserver`, you also need to be running the node dev server on another terminal, as in

```
cd frontend 
npm start
```


## Pruebas end to end

### Installing Cypress

we are using cypress for e2e testing. To install it, go to frontend and run

```
npm i
```

In order to run the tests:

```
npm run cypress open
```

### Cypress folders

In frontend, you have a cypress folder containing:
```
fixtures/ --> contains files that help you mock some behaviors, such as uploading a file, mocking api...

integration/ --> contains tests files

plugins/ --> make config changes before running tests (use fs, Change the list of browsers used for testing...)

support/let you create new cypress command (for example click on some text instead of using css selectors)
```
  

### Structure of a test

Tests have the following structures
```
describe('[description of what general feature we are testing (login, register...])', () => {
    describe('when ... [description of the use case: (when I am already logged in, when I am clickin on...])' () => {
        it('should ... [expected behavior]', () => {

        })
    })
})
```

### Some cypress command:

```  
cy.visit('https://google.fr') // visit google.fr

cy.get('a').click() // click on a element (a must be unique)

cy.get('input[text]').type() // fill a text input (input must be unique)

cy.get('select').select(21) // fill a select using option matching value (<option  value="21"> in this case)

cy.get('a').should('exist') // check that an a element exist on the page

```
  
### Some cypress tricks:

#### wait
```
cy.wait() // cypress is not always smart enough to wait for async js to run, so you might have to wait.
```
  

In order to select element, you should use cy dataset on html element (data set of an element is an attribute startin by data-, so in this case data-cy)

  

for exemple, if you want to select the following div element:

```
< div  class="a-class">

< /div>
```

don't:
```
cy.get('.a-class')
```
  

do:

change the div to --> 
```
< div  class="a-class"  data-cy="a-div">< /div>
```
then
```
cy.get('[data-cy=a-div]')
```
  

### Useful should statement

```
cy.get('a').should('exist') // check that an a element exist on the page

cy.get('a').should('be.visible') // check that an a element is visible on the page (display property !== none)

cy.get('a').should('not.be.visible') // check that an a element is not visible on the page (display property === none)

cy.get('a').should('have.class', 'my-class') // check that an a element has the class 'my-class'

cy.get('input').should('have.value', 'my-value') // check that an input element has the value 'my-value'
```

### Login for the first time

The first time you run the tests, you'll have to manually perform login. In order to do that, look for

```
cy.get('[data-cy="login-with-google"]').click()
```

change it for

```
cy.wait(30000)
```

run the test, and when cypress is waiting for 30seconds, perform login manually. Then change back the test. You'll be logged in for ~15 days.

##  Production 

### Build docker container

Note: you'll need AWS CLI installed in your machine to be able to do this.
Should've been installed when you ran `pip install -r requirements.txt`

DONT FORGET TO RUN THE FIRST COMMAND! Otherwise the frontend and backend will
diverge!

Also, make sure you configured the AWS CLI (use us-east-1):
`aws configure`

```
# Build frontend files
cd frontend && npm run build

docker build -t admin.flat.mx . && docker tag admin.flat.mx:latest 711300859214.dkr.ecr.us-east-1.amazonaws.com/admin.flat.mx:latest

# Make sure you configured the AWS CLI (use us-east-1):
aws configure

$(aws ecr get-login --no-include-email --region us-east-1) && 
docker push 711300859214.dkr.ecr.us-east-1.amazonaws.com/admin.flat.mx:latest
```

### Staging

Eventually, we'd like to automate this using fabric or some other remote ssh
tool, but for now a manual way works well.

```
# Use EC2 instance's Elastic IP - dns directs to cloudflare
ssh ubuntu@3.221.72.42 -i ~/Downloads/ec2.pem
# Once logged in
$(aws ecr get-login --no-include-email --region us-east-1) && docker pull 711300859214.dkr.ecr.us-east-1.amazonaws.com/admin.flat.mx:latest
docker-compose down
docker-compose up -d
```

### Deploying on server 

Eventually, we'd like to automate this using fabric or some other remote ssh
tool, but for now a manual way works well.

```
# Use EC2 instance's Elastic IP - dns directs to cloudflare
ssh ubuntu@52.205.115.138 -i ~/Downloads/ec2.pem
# Once logged in
$(aws ecr get-login --no-include-email --region us-east-1) && docker pull 711300859214.dkr.ecr.us-east-1.amazonaws.com/admin.flat.mx:latest
docker-compose down
docker-compose up -d
```

## Run locally:

```
docker run --name postgres -d postgres
# Redis as a Celery broker
docker run -p 6379:6379 --name redis -d redis 

# Run celery (optional)
celery -A test worker -l info

# Migrate postgres
docker run -it \
    --link postgres \
    -e DJANGO_ENV=DEV \
    -e POSTGRESQL_DB_NAME=postgres \
    -e POSTGRESQL_HOST=postgres \
    -e POSTGRESQL_USER=postgres \
    admin.flat.mx:latest python manage.py migrate

# You'll probably need to add fixtures, you can do so with `python manage.py loaddata all.json`

# Start webserver
docker run -p 80:8000 -it \
    --link postgres \
    -e DJANGO_ENV=DEV \
    -e POSTGRESQL_DB_NAME=postgres \
    -e POSTGRESQL_HOST=postgres \
    -e POSTGRESQL_USER=postgres \
    -e GOOGLE_LOGIN_CLIENT_ID=myclientid \
    -e GOOGLE_LOGIN_SECRET_KEY=mysecretkey \
    admin.flat.mx:latest
```
## Troubleshooting checklist

Make sure you've

- Got python3 installed
- Created and copied `vars.env` from this document.
- Created and copied `test/settings/local.py` from `test/settings/local.py.template`
- `vars.env` contains appropriate user and database names (if using postgres.app use OS username as dbname and user)
- Sourced `vendor/bin/activate` and `vars.env`