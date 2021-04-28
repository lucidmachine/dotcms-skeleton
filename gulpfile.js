var gulp = require('gulp')
var webdav = require('gulp-webdav-sync')
var livereload = require('gulp-livereload')
var request = require('request')

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
	tasks[index].dav.pathhost = element.pathhost
})

function handleGulpError (error) {
	console.log(error.toString())
	this.emit('end')
}

/**
 * Derive WebDAV request options from a given WebDAV method, path, and options object.
 *
 * @param method string The request method.
 * @param path string The path of the collection or file we're requesting.
 * @param options object Additional WebDAV request options.
 */
function webdavOptions(method, path, options) {
	const pathname = `${davPath}/${options.pathhost}/${path}`
	const uri = `${options.protocol}//${options.hostname}:${options.port}${pathname}`

	return Object.assign({}, options, {
		method: method,
		uri: uri,
		pathname: pathname
	})
}

/**
 * Create a directory path in WebDAV.
 *
 * Attempts to make each directory path above the target path from root to leaf.
 *
 * For example, if `path` is '/foo/bar/baz' we will attempt to create:
 * # '/foo'
 * # '/foo/bar'
 * # '/foo/bar/baz'
 *
 * @param path string The path to be created.
 * @param options object HTTP options for requests to the WebDAV server.
 * @param successFn function Function to be called when the given path has been created.
 */
function mkdirp(path, options, successFn) {
	const canonicalPath = path.replace(/\\/g, '/')
	const paths = canonicalPath.split('/')
		.slice(1)
		.reduce((acc, curr) => {
			const parent = acc[acc.length - 1] || ''
			return [...acc, `${parent}${curr}/`]
		}, [])

	_mkdirp(paths, options, successFn)
}

/**
 * Create each of the given paths recursively.
 *
 * @param paths string[] Paths to create. Assumed to be ordered from root to leaf.
 * @param prevOptions object HTTP options for requests to the WebDAV server.
 * @param callbackFn function Function to call when we're done seeking paths.
 */
function _mkdirp(paths, prevOptions, callbackFn) {
	if (paths.length === 0) {
		return callbackFn()
	}
	const head = paths[0]
	const tail = paths.slice(1)
	const currOptions = webdavOptions('MKCOL', head, prevOptions)

	request(currOptions) 
		.on('response', res => {
			console.log(`${res.statusCode} ${head}`)
			_mkdirp(tail, currOptions, callbackFn)
			callbackFn()
		})
		.on('error', err => console.error(err))
}


tasks.forEach((element, index) => {

	gulp.task(element.taskname, function () {
		livereload.options.port = davClientPort + index
		livereload.listen()

		console.log(element.taskname, "Task Watcher: ", element.watchpaths)

		gulp.watch(element.watchpaths).on(element.watchevents, function (file) {
			const canonicalPath = file.replace(/\\/g, '/')

			// Try to sync the changed file
			gulp.src(canonicalPath)
				.pipe(webdav(element.dav))
				.on('error', () => {

					// Create any missing intermediate paths and retry. dotCMS tries but fails to create
					// missing paths for PUT requests so we're working around it from the client side.
					// See: https://github.com/dotCMS/core/issues/20300
					const parentPath = canonicalPath.slice(0, canonicalPath.lastIndexOf('/'))
					request(webdavOptions('HEAD', parentPath, element.dav))
						.on('response', res => {
							if (res.statusCode !== 200) {

								// The parent path was missing. Create it and retry.
								mkdirp(parentPath, element.dav, () => {
									gulp.src(canonicalPath)
										.pipe(webdav(element.dav))
										.on('error', handleGulpError)
								})
							}
						})
				})
		});
	});
})
