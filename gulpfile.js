var gulp = require('gulp')
var webdav = require('gulp-webdav-sync')
var livereload = require('gulp-livereload')

var davPath = "/webdav/live/1"

// gulpCreds array should mirror index of gulpSites
var gulpCreds = require("./gulp-config/gulp-creds.js")
var gulpSites = require("./gulp-config/gulp-sites.js")
var davClientPort = require("./gulp-config/gulp-port.js")

// Default Options
var davDefaults = {
	protocol: 'http:',
	hostname: null,
	port: 8080,
	base: null,
	pathname: null,
	log: 'info',
	logAuth: false,
	uselastmodified: 11000
}

var tasks = [];
gulpSites.forEach((element, index) => {
	tasks[index] = {
		dav: Object.assign({}, davDefaults),
		taskname: element.taskname,
		watchevents: element.watchevents,
		watchpaths: element.watchpaths
	};
	tasks[index].dav.auth = gulpCreds[index]
	tasks[index].dav.hostname = element.hostname
	tasks[index].dav.protocol = element.protocol
	tasks[index].dav.port = element.port
	tasks[index].dav.base = process.cwd() + '/' + element.pathhost
	tasks[index].dav.pathname = davPath + '/' + element.pathhost + '/'
})

function handleGulpError (error) {
	console.log(error.toString())
	this.emit('end')
}

tasks.forEach((element, index) => {

	gulp.task(element.taskname, function () {
		livereload.options.port = davClientPort + index
		livereload.listen()

		console.log(element.taskname, "Task Watcher: ", element.watchpaths)

		gulp.watch(element.watchpaths).on(element.watchevents, function (file) {
			gulp.src(file.replace(/\\/g, '/'))
				.pipe(webdav(element.dav))
				.on('error', handleGulpError)
		});
	});
})
