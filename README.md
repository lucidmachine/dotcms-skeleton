# dotCMS Project Skeleton

## Preface

- Each Site should have its own subdirectory in the project root eg: `example.com`
- Site directories and files are organized according to current best practices
- **NOTE:** *Never* assume the local repo is in sync with dotcms as deployment is one-way

## Getting started

1. Clone repo. 
1. If you are starting with a fresh and empty instance of dotcms, continue. Otherwise, skip the remaining steps.
1. `cd` to project root
1. Run `scripts/init.sh`, all options are optional
	- Configures gulp webDAV and creates appropriate files `gulp-config/gulp-creds.js`, `gulp-config/gulp-sites.js`
	- Deletes `deleteme` files
	- Creates standard directory structure in dotcms, if you opted to configure gulp
	- Installs NPM dependancies


## To use Gulp Uploader

This gulp task will watch directories for files that have changed, then upload via WebDAV automagically.

#### If you didn't run `init.sh` script and want to configure manually:

1. Run `npm install gulp-cli -g`
1. Run `npm install`
1. Edit your dotcms credentials in `gulp-config/gulp-creds.js`. This file is already in .gitignore
1. Edit task configration in `gulp-config/gulp-sites.js`

> **Important**: When doing a `git pull`, end the Gulp Uploader task first! It must *not* be running when git does it's thing. Gulp will upload the *old* version of every file git wants to change. If it's too late and this already happened, don't panic! Take a list of the changed files from the console output and `touch` them. This will upload the correct version back to dotcms.

> **Note**: Newly created files will initially return a HTTP `500`. As long as gulp reports a following `201`, you're good to go!

### gulp-creds.js example:
```
module.exports = { 
	user: "username",
	pass: "password"
};
```

### gulp-sites.js example:
```
module.exports = [
	{
		'hostname': "dev.domain.com",
		'pathhost': "domain.com",
		'taskname': "live-push",
		'protocol': "http:",
		'port': 8080,
		'watchevents': ['change'],
		'watchpaths': [
			"demo.dotcms.com/**"
		]
	}
]
```

> Run `gulp live-push` to start the task. `live-push`


### Stuff

- When working with a group, mind file locks in dotcms. The DAV module does not recognize locked files in dotcms, so make sure:
 - Files you're working on are locked.
 - Do not edit files that are locked by someone else.
- Gulp will listen for file changes configured in `gulp-config/gulp-sites.js` `watchpaths` array.
- Directories must already exist in dotCMS or the file won't upload (you'll get a 500). You can either create the directory in dotCMS, or use a DAV client. I don't know if this is a limitation of the module, or some other bug. Feel free to fix it 🐞
- You can create new files on the fly, so long as the parent directory exists, but the initial save will return 500, but subsequent writes will save properly. Avoid saving empty files, dotCMS doesn't like them.
- If you want to create a bunch of new files in the tree, I recommend using a client. Otherwise, you'll need to open each new file and write to it manually.
