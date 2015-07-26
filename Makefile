ENV=./env/bin
PATH  := node_modules/.bin:$(PATH)
SHELL := /bin/bash

build.css: 
	mkdir -p static/css
	lessc less/style.less static/css/bundle.css
	autoprefixer static/css/bundle.css

build.js:
	mkdir -p static/js
	browserify js/app.js -o static/js/bundle.js

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
	$(ENV)/pip install -r requirements/development.txt --upgrade

prod:
	$(ENV)/pip install -r requirements/production.txt --upgrade

env:
	virtualenv -p `which python3` env

clean:
	pyclean .
	find . -name "*.pyc" -exec rm -rf {} \;
	rm -rf *.egg-info

test:
	$(ENV)/python setup.py test

#run:
#	$(ENV)/python gso.py

freeze:
	mkdir -p requirements
	$(ENV)/pip freeze > requirements/base.txt
