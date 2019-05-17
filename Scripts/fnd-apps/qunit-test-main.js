window.vbInitConfig = {
	SERVICE_WORKER_CONFIG: {
		disabled: true
	}
};


var allCCALoaders = [];
var commonTestFiles = [];
// var TEST_REGEXP = /(-test)\.js$/i

// check if the test file is present in any of the directory or sub directory of the packages to be tested.
function isAddTestFile(testSuiteFile) {
	var testFile = false;
	// check if any packages are passed as arguments to the karma start command.
	if (window.__karma__.config.args && window.__karma__.config.args.length > 0) {
		// If all is present as only argument then test all the suites.
		if (window.__karma__.config.args[0] === 'all') {
			testFile = true;
		} else {
			// else for each package check if it is part of file, if yes then execute the test suite.
			for (var i = 0; i < window.__karma__.config.args.length; i++) {
				if (testSuiteFile.indexOf(window.__karma__.config.args[i]) >= 0) {
					testFile = true;
					break;
				}
			}
		}
	} else {
		// If no packages are defined then execute all the test suites.
		testFile = true;
	}
	// console.log('Run Tests in Test suite: ' + testSuiteFile + " : " + testFile);
	return testFile;
}

Object.keys(window.__karma__.files).forEach(function(file) {
	if (file.endsWith('loader.js') && file.indexOf('/js/jet-composites') >= 0) {
		console.log('Adding CCA Loader ' + file);
		allCCALoaders.push(file);
	}
	if (file.indexOf('-test.js') >= 0 && file.indexOf('/js/jet-composites') >= 0 && file.indexOf('/qunit/') >= 0 && isAddTestFile(file)) {
		console.log('Run tests in test suite ' + file);
		commonTestFiles.push(file);
	}
});

allCCALoaders = allCCALoaders.map(loader => loader.replace('/base/src/js/jet-composites', 'oj-approvals').replace('.js', ''));

require.config({
	// Karma serves files under /base, which is the basePath from your config file
	//  baseUrl: '/base',
	waitSeconds: 0,
	paths: {
		'oj-approvals': '/base/src/js/jet-composites',
		'app-flow': '/base/tests/fixture/app-flow',
		underscore: '/base/node_modules/underscore/underscore',
		pouchdb: '/base/node_modules/@oracle/oraclejet/dist/js/libs/opt/min/pouchdb-browser-6.3.4',
		'oj-dynamic': 'https://static-stage.oracle.com/cdn/jet/packs/oj-dynamic/6.0.0-alpha.1.1'
	}
});

Promise.all([
	requirePromise(allCCALoaders, 'CCA Loaders'),
	requirePromise(commonTestFiles, 'Common Test Files')
]).finally(() => {
  setTimeout( () => window.__karma__.start(), 1000);
});

function requirePromise(deps, resource) {
	console.log('Loading resource ' + resource);

	return new Promise((r, f) => require(
		deps,
		() => {
			console.log('Resource Loaded: ' + resource);
			r();
		}, (error) => {
			console.error('Unable to require ' + resource);
			console.error(error);
			f();
		}
	));
}

const Colors = {
  Reset: "\x1b[0m",
  Bright: "\x1b[1m",
  Dim: "\x1b[2m",
  Underscore: "\x1b[4m",
  Blink: "\x1b[5m",
  Reverse: "\x1b[7m",
  Hidden: "\x1b[8m",
  fg: {
   Black: "\x1b[30m",
   Red: "\x1b[31m",
   Green: "\x1b[32m",
   Yellow: "\x1b[33m",
   Blue: "\x1b[34m",
   Magenta: "\x1b[35m",
   Cyan: "\x1b[36m",
   White: "\x1b[37m",
   Crimson: "\x1b[38m" //القرمزي
  },
  bg: {
   Black: "\x1b[40m",
   Red: "\x1b[41m",
   Green: "\x1b[42m",
   Yellow: "\x1b[43m",
   Blue: "\x1b[44m",
   Magenta: "\x1b[45m",
   Cyan: "\x1b[46m",
   White: "\x1b[47m",
   Crimson: "\x1b[48m"
  }
};

QUnit.testStart(function( details ) {
  var message = Colors.bg.White + Colors.Bright + ' NOW TESTING ' + '\x1b[49m' + ' ' + details.module + "-" + details.name;
  console.info(message + Colors.Reset);
});

QUnit.testDone(function( details ) {	
  var testMessage = details.module + "-" + details.name; 
  
  var statusColor, statusText;
  statusColor = Colors.bg.Green;
  statusText =   "  PASSED  ";
 
  if (details.failed > 0) {
    statusColor = Colors.bg.Red;
    statusText = "  FAILED  ";
  } else if (details.skipped) {
    statusColor = Colors.bg.White;
    statusText = "  SKIPPED ";
  } else if (details.todo) {
    statusColor = Color.bg.Yellow;
    statusText = "   TODO   ";
  }

  var message = statusColor + ' ' + '\x1b[1m' + statusText + ' ' + '\x1b[49m' + ' ' + testMessage;
  console.info(message + Colors.Reset);
});
