module.exports = [
	{
		'hostname': "website.com",
		'pathhost': "website.com",
		'taskname': "live-push",
		'protocol': "http:",
		'port': 8080,
		'watchevents': ['change'],
		'watchpaths': [
			"website.com/**"
		]
	}
]
