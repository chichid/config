/**
 * Mocha (JSON) reporter for QUnit
 *
 * https://github.com/xnimorz/qunit-mocha-reporter
 *
 */
/* global QUnit, define, module, exports */
(function() {
    'use strict';

    var tests;
    var currentTest;
    var callback;

    QUnit.begin(function() {
        tests = {
            stats: {
                suites: 0,
                tests: 0,
                passes: 0,
                pending: 0,
                failures: 0,
                duration: 0,
                start: new Date(),
                end: 0
            },
            failures: [],
            passes: [],
            skipped: []
        };
    });

    QUnit.testStart(function(data) {
        currentTest = {
            title: data.name,
            fullTitle: (data.module ? '[' + data.module + ']: ' : '')+ data.name,
            duration: 0,
            startTime: new Date()
        };
    });

    QUnit.log(function(data) {
        if (data.result) {
            tests.passes.push(currentTest);
        } else {
            currentTest.error = data.source;
            tests.failures.push(currentTest);
        }
    });

    QUnit.testDone(function() {
        currentTest.duration = (new Date()).getTime() - currentTest.startTime.getTime();

        currentTest = null;
    });

    QUnit.done(function(data) {
        tests.stats.end = new Date();
        tests.stats.duration = data.runtime || (tests.stats.end.getTime() - tests.stats.start.getTime());
        tests.stats.suites = data.total;
        tests.stats.tests = data.total;
        tests.stats.passes = data.passed;
        tests.stats.failures = data.failed;

        callback(tests);
    });

    function defineCallback(testsDoneCallback) {
        callback = testsDoneCallback;
    }

    (function(defineCallback) {
        if (typeof exports === 'object') {
            // CommonJS
            // CommonJS должен стоять первым, чтобы инициализация по возможности - была синхронной
            module.exports = defineCallback;
        } else if (typeof define === 'function' && define.amd) {
            // AMD.
            define(defineCallback);
        } else {
            // Global scope
            window.qUnitDefineCallback = defineCallback;
        }
    })(defineCallback);

})();


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

QUnit.log(function( details ) {
  if ( details.result ) {
    return;
  }
  
  var output = '';

  if ( details.message ) {
    output += details.message  + '\n';
  }

  if ( details.actual ) {
    output += "expected: " + details.expected + ", actual: " + details.actual + '\n';
  }
 
  if ( details.source ) {
    output +=  details.source + '\n';
  }
  
  // output = output.replace(new RegExp(location.href.replace(location.pathname, ''), 'g'), '');
  
  console.log( output );
});

