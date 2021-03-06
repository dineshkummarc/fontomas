PROJECT     :=  $(notdir ${PWD})
TMP_PATH    := /tmp/${PROJECT}-$(shell date +%s)

REMOTE_NAME ?= origin
REMOTE_REPO ?= $(shell git config --get remote.${REMOTE_NAME}.url)


help:
	echo "make help			- Print this help"
	echo "make app-start		- Run Fontomas server"
	echo "make rebuild-fonts	- Rebuild embedded fonts"
	echo "make dev-setup		- Install deps for development"
	echo "make lint			- Lint sources with JSHint"
	echo "make gh-pages		- Build and push the project into gh-pages branch"


app-start:
	node ./index.js


rebuild-fonts:
	bin/build_embedded_fonts.py


dev-setup:
	rm -rf node_modules
	npm install
	npm install -g jshint


lint:
	if test ! `which jshint` ; then \
		echo "You need 'jshint' installed in order to run lint." >&2 ; \
		exit 128 ; \
		fi
	jshint . --show-non-errors


gh-pages:
	@if test -z ${REMOTE_REPO} ; then \
		echo 'Remote repo URL not found' >&2 ; \
		exit 128 ; \
		fi
	cp -r ./ ${TMP_PATH} && \
		touch ${TMP_PATH}/.nojekyll
	cd ${TMP_PATH} && \
		git init && \
		git add . && \
		git commit -q -m 'refreshed at gh-pages'
	cd ${TMP_PATH} && \
		git remote add remote ${REMOTE_REPO} && \
		git push --force remote +master:gh-pages 
	rm -rf ${TMP_PATH}

todo:
	grep 'TODO' -n -r ./lib 2>/dev/null || test true


.PHONY: help app-start rebuild-fonts dev-setup lint gh-pages todo
.SILENT: help app-start rebuild-fonts dev-setup lint todo
