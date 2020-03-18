#!/bin/sh
read -p "Configure gulp webDAV [y/n]? " -r OPT_GULP_ADD_WEBDAV
echo ""

if [[ $OPT_GULP_ADD_WEBDAV =~ ^[Yy]$ ]] ; then
	echo "[NOTICE]: For gulp to be functional, be sure to have gulp-cli installed globally, or use gulp binary in node_modules"
	echo ""

	read -p "Enter host FQDN or IP: " -r DC_REMOTE_HOST
	read -p "Enter host protocol [\"http\" or \"https\"]: " -r DC_HOST_PROTO
	read -p "Enter host port: " -r DC_HOST_PORT
	read -p "Enter dotcms username: " -r DC_USER
	read -p "Enter dotcms password: " -r DC_PASS
	read -p "Enter dotcms site domain name: " -r DC_SITEHOST
	echo ""
fi


if [[ $OPT_GULP_ADD_WEBDAV =~ ^[Yy]$ ]] ; then
	echo "writing to gulp-config/gulp-sites.js"
	echo "module.exports = [" > gulp-config/gulp-sites.js
	echo "	{" >> gulp-config/gulp-sites.js
	echo "		'hostname': \"${DC_REMOTE_HOST}\"," >> gulp-config/gulp-sites.js
	echo "		'pathhost': \"${DC_SITEHOST}\"," >> gulp-config/gulp-sites.js
	echo "		'taskname': \"live-push\"," >> gulp-config/gulp-sites.js
	echo "		'protocol': \"${DC_HOST_PROTO}:\"," >> gulp-config/gulp-sites.js
	echo "		'port': ${DC_HOST_PORT}," >> gulp-config/gulp-sites.js
	echo "		'watchevents': ['change']," >> gulp-config/gulp-sites.js
	echo "		'watchpaths': [" >> gulp-config/gulp-sites.js
	echo "			\"${DC_SITEHOST}/**\"" >> gulp-config/gulp-sites.js
	echo "		]" >> gulp-config/gulp-sites.js
	echo "	}" >> gulp-config/gulp-sites.js
	echo "]" >> gulp-config/gulp-sites.js
	echo "done..."
fi
echo ""

if [[ $OPT_GULP_ADD_WEBDAV =~ ^[Yy]$ ]] ; then
	echo "writing to gulp-config/gulp-creds.js"
	echo "module.exports = [" > gulp-config/gulp-creds.js
	echo "	{" >> gulp-config/gulp-creds.js
	echo "		user: \"${DC_USER}\"," >> gulp-config/gulp-creds.js
	echo "		pass: \"${DC_PASS}\"" >> gulp-config/gulp-creds.js
	echo "	}" >> gulp-config/gulp-creds.js
	echo "]" >> gulp-config/gulp-creds.js
	echo "done..."
fi
echo ""

if [[ $OPT_GULP_ADD_WEBDAV =~ ^[Yy]$ ]] ; then
read -p "Create dotCMS directory structure on host ${DC_REMOTE_HOST} [y/n]? " -r OPT_DC_CREATE_DIRS

	if [[ $OPT_DC_CREATE_DIRS =~ ^[Yy]$ ]] ; then
		AUTH_STR=$(echo -n "${DC_USER}:${DC_PASS}" | base64 -w 0)
		echo ""
		echo "Sending Requests to ${DC_REMOTE_HOST}..."
		echo ""
		echo ${AUTH_STR}
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/application
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/application/apivtl
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/application/async
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/application/containers
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/application/content-types
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/application/custom-fields
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/application/includes
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/application/macros
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/application/template-custom
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/application/themes
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/application/themes/default
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/application/util
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/application/util/css
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/application/util/js
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/application/util/reports
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/application/util/vtl
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/application/widgets
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/css
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/documents
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/downloads
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/img
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/js
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/json
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/media
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/message
		curl -H "Authorization:Basic ${AUTH_STR}" -X MKCOL ${DC_HOST_PROTO}://${DC_REMOTE_HOST}:${DC_HOST_PORT}/webdav/live/1/${DC_SITEHOST}/static
		echo "Requests finished..."
	fi
fi

DC_USER=""
DC_PASS=""
AUTH_STR=""

read -p "Remove deleteme files [y/n]? " -r OPT_REMOVE_DELETEME

if [[ $OPT_REMOVE_DELETEME =~ ^[Yy]$ ]] ; then
	find . -type f -name deleteme -delete
fi

echo ""
echo "NPM Dependancies: gulp gulp-livereload gulp-watch gulp-webdav-sync foundation-sites jquery vue"
echo ""
read -p "Install NPM dependancies [y/n]? " -r OPT_NPM_INSTALL

if [[ $OPT_NPM_INSTALL =~ ^[Yy]$ ]] ; then
	npm install
fi