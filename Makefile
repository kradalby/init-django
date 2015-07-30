ENV=./env/bin
PATH  := node_modules/.bin:$(PATH)
SHELL := /bin/bash
PYTHON=$(ENV)/python
PIP=$(ENV)/pip
MANAGE=$(PYTHON) manage.py

build.css: 
	mkdir -p static/css
	lessc less/style.less static/css/bundle.css
	autoprefixer static/css/bundle.css

build.js:
	mkdir -p static/js
	browserify js/app.js -o static/js/bundle.js

collect_static:
	mkdir collected_static
	$(MANAGE) collectstatic


build: build.js build.css

watch.css: 
	nodemon -I -w less/ --ext less --exec 'make build.css' &

watch.js:
	watchify js/app.js -o static/js/bundle.js -v &

watch: watch.css watch.js

jshint:
	jshint --reporter node_modules/jshint-stylish/stylish.js js/; true

dev: 
	npm install
	$(PIP) install -r requirements/development.txt --upgrade

prod:
	$(PIP) install -r requirements/production.txt --upgrade

env:
	virtualenv -p `which python3` env

clean:
	pyclean .
	find . -name "*.pyc" -exec rm -rf {} \;
	rm -rf *.egg-info

test:
	$(MANAGE) test

run:
	$(MANAGE) runserver 0.0.0.0:8000

freeze:
	mkdir -p requirements
	$(PIP) freeze > requirements/base.txt
