window.vbInitConfig = {
  SERVICE_WORKER_CONFIG: {
    disabled: true,
  },
  LOG: { mode: 'simple', emoji: 'off' },
};

var TRANSLATION_OVERRIDE_PATH = '/resources/translations/nls/oracle.apps.fnd.applcore.vbcs.flows.approvals';
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

Object.keys(window.__karma__.files)
  .forEach(function(file) {
    if (file.endsWith('loader.js') && file.indexOf('/js/jet-composites') >= 0) {
      console.log('Adding CCA Loader ' + file);
      allCCALoaders.push(file);
    }
    if (file.indexOf('-test.js') >= 0 && file.indexOf('/js/jet-composites') >= 0 && file.indexOf('/qunit/') >= 0 && isAddTestFile(file)) {
      console.log('Run tests in test suite ' + file);
      commonTestFiles.push(file);
    }
  });

allCCALoaders = allCCALoaders.map(loader => loader.replace('/base/src/js/jet-composites', 'oj-approvals')
  .replace('.js', ''));

require.config({
  // Karma serves files under /base, which is the basePath from your config file
  //  baseUrl: '/base',
  waitSeconds: 0,
  paths: {
    'oj-approvals': '/base/src/js/jet-composites',
    'app-flow': '/base/tests/fixture/app-flow',
    underscore: '/base/node_modules/underscore/underscore',
    pouchdb: '/base/node_modules/@oracle/oraclejet/dist/js/libs/opt/min/pouchdb-browser-6.3.4',
    'oj-dynamic': 'https://static-stage.oracle.com/cdn/jet/packs/oj-dynamic/6.0.0-alpha.1.1',
  },
  config: {
    ojL10n: {
      merge: {
        'oj-approvals/common/resources/nls/oj-common-strings': TRANSLATION_OVERRIDE_PATH,
        'oj-approvals/stepflow-editor/resources/nls/oj-fnd-approvals-stepflow-editor-strings': TRANSLATION_OVERRIDE_PATH,
        'oj-approvals/rule-editor/resources/nls/oj-approvals-rule-editor-strings': TRANSLATION_OVERRIDE_PATH,
        'oj-approvals/rule-action-editor/resources/nls/oj-approvals-rule-action-editor-strings': TRANSLATION_OVERRIDE_PATH,
        'oj-approvals/rule-condition-editor/resources/nls/oj-approvals-rule-condition-editor-strings': TRANSLATION_OVERRIDE_PATH,
        'oj-approvals/authority-row-editor/resources/nls/oj-approvals-authority-row-editor-strings': TRANSLATION_OVERRIDE_PATH,
      },
    },
  },
});

require(['/base/tests/fixture/qunit-reporter'], function() {
  var count = 0;
  function onScriptLoaded() {
    count++;

    if (count >= 2) {
      window.__karma__.start();
    }
  }

  require(allCCALoaders, onScriptLoaded, onScriptLoaded); 
  require(commonTestFiles, onScriptLoaded, onScriptLoaded);
});

