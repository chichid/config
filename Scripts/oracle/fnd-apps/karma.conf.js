// Karma configuration
// Generated on Sat Oct 21 2017 12:58:07 GMT+0530 (India Standard Time)

// const ChromiumRevision = require('puppeteer/package.json').puppeteer.chromium_revision;
// const Downloader = require('puppeteer/utils/ChromiumDownloader');
// const revisionInfo = Downloader.revisionInfo(Downloader.currentPlatform(), ChromiumRevision);

// process.env.CHROME_BIN = revisionInfo.executablePath;

const path = require('path');
const process = require('process');

// process.env.CHROME_BIN = require('puppeteer').executablePath();

module.exports = function(config) {
  config.set({
    // base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: '',

    // frameworks to use
    // available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ['requirejs', 'qunit', 'fixture'],

    plugins: [
      'karma-requirejs',
      'karma-qunit',
      //'karma-coverage',
      //'karma-coverage-istanbul-reporter',
      'karma-chrome-launcher',
      //'karma-firefox-launcher',
      //'karma-webdriver-launcher',
      //'karma-json-reporter',
      //'karma-junit-reporter',
      'karma-fixture',
      'karma-typescript-preprocessor',
      'karma-scss-preprocessor',
    ],

    proxies: {
      // Proxy for translations
      '/resources/translations/nls/': '/absolute' + path.resolve('webApps/fnd-apps/resources/translations/nls/'),
    },

    // list of files / patterns to load in the browser
    files: [
      'https://static.oracle.com/cdn/jet/v6.0.0/default/js/bundles-config.js',
      'tests/qunit-test-main.js',
      'node_modules/@oracle/vb/lib/third-party-libs.js',
      'node_modules/@oracle/vb/visual-runtime.js',
      {
        pattern: '../webApps/fnd-apps/resources/translations/nls/**/*.*',
        served: true,
        included: false,
      },
      {
        pattern: 'tests/fixture/**/*.*',
        served: true,
        included: false,
      },
      {
        pattern: 'node_modules/@oracle/oraclejet/dist/css/alta/oj-alta-min.css',
        included: true,
        watched: false,
      },
      {
        pattern: 'node_modules/**/*.*',
        included: false,
        watched: false,
      },
      {
        pattern: 'src/**/*.*',
        included: false,
        watched: true,
      },
      {
        pattern: 'tests/js/jet-composites/**/*.*',
        included: false,
        watched: true
      },
    ],

    // list of files to exclude
    exclude: ['src/js/jet-composites/@types/*'],

    // preprocess matching files before serving them to the browser
    // available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {
      'tests/js/jet-composites/**/*.ts': ['typescript'],
      'src/js/jet-composites/**/*.ts': ['typescript'],
      'src/js/jet-composites/**/*.scss': ['scss'],
    },

    typescriptPreprocessor: {
      // options passed to the typescript compiler
      options: {
        sourceMap: false, // (optional) Generates corresponding .map file.
        target: 'ES5', // (optional) Specify ECMAScript target version: 'ES3' (default), or 'ES5'
        module: 'amd', // (optional) Specify module code generation: 'commonjs' or 'amd'
        noImplicitAny: true, // (optional) Warn on expressions and declarations with an implied 'any' type.
        noResolve: true, // (optional) Skip resolution and preprocessing.
        removeComments: true, // (optional) Do not emit comments to output.
        concatenateOutput: false, // (optional) Concatenate and emit output to single file.
        // By default true if module option is omited, otherwise false.
      },

      // transforming the filenames
      transformPath: function(_path) {
        return _path.replace(/\.ts$/, '.js');
      },
    },

    scssPreprocessor: {
      options: {
        sourceMap: true,
      },
    },

    // test results reporter to use
    // possible values: 'dots', 'progress'
    // available reporters: https://npmjs.org/browse/keyword/karma-reporter
    // reporters: ['progress', 'junit', 'html', 'htmlDetailed','json'],
    // reporters: ['progress', 'json', 'junit', 'coverage', 'coverage-istanbul'],

    jsonReporter: {
      stdout: false,
      outputFile: 'reports/unit-tests/json-reporter/results.json', // defaults to none
    },

    junitReporter: {
      outputDir: 'reports/unit-tests/junit-reporter', // results will be saved as $outputDir/$browserName.xml
    },

    coverageIstanbulReporter: {
      reports: ['html', 'json'],
      dir: path.join(__dirname, 'reports/unit-tests/coverage'),
      combineBrowserReports: true,
      watermarks: {
        statements: [50, 90],
        branches: [1, 2],
        functions: [1, 2],
        lines: [1, 2],
      },
    },

    coverageReporter: {
      dir: 'reports/unit-tests/coverage',
      instrumenterOptions: {
        istanbul: { noCompact: true },
      },
      reporters: [{ type: 'html' }, { type: 'json' }],
      watermarks: {
        statements: [50, 90],
        branches: [1, 2],
        functions: [1, 2],
        lines: [1, 2],
      },
    },

    hostname: '127.0.0.1',
    port: 9875,

    // enable / disable colors in the output (reporters and logs)
    colors: true,

    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_ERROR,

    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: true,

    // start these browsers
    // available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    // 'ChromeHeadless' does not work for debug in Karma, use Firefox for now
    browsers: ['ChromeHeadless'],

    customLaunchers: {
      ChromeDebugger: {
        base: 'Chrome',
        flags: ['--start-fullscreen', '--auto-open-devtools-for-tabs ', 'http://localhost:9875/debug.html'],
        debug: false,
      },
      ChromeHeadless: {
        base: 'Chrome',
        flags: ['--headless', '--disable-gpu', '--remote-debugging-port=9222', '--no-sandbox'],
        debug: false,
      },
      HeadlessChrome: {
        base: 'Chrome',
        flags: ['--headless', '--disable-gpu', '--remote-debugging-port=9222', '--no-sandbox'],
      },
      Android: {
        base: 'WebDriver',
        platformName: 'Android',
        deviceName: 'emulator-5554',
        config: {
          hostname: '127.0.0.1',
          port: 4723,
        },
        newCommandTimeout: 1800,
        browserName: 'Chrome',
        chromedriverExecutableDir: process.cwd() + '/build/chromedriver/win32',
        chromedriverChromeMappingFile: process.cwd() + '/build/chromedriver/chromedriver-chrome-compatability.json',
      },
      iOS: {
        base: 'WebDriver',
        platformName: 'iOS',
        platformVersion: '11.4',
        deviceName: 'iPhone X',
        config: {
          hostname: '127.0.0.1',
          port: 4723,
        },
        newCommandTimeout: 1800,
        browserName: 'Safari',
        automationName: 'XCUITest',
        chromedriverExecutableDir: process.cwd() + '/build/chromedriver/win32',
        chromedriverChromeMappingFile: process.cwd() + '/build/chromedriver/chromedriver-chrome-compatability.json',
      },
    },

    // Continuous Integration mode
    // if true, Karma captures browsers, runs the tests and exits
    singleRun: false,

    retryLimit: 3,
    captureTimeout: 30000,
    browserDisconnectTimeout: 120000,
    browserDisconnectTolerance: 3,
    browserNoActivityTimeout: 120000,

    // Concurrency level
    // how many browser should be started simultaneous
    concurrency: Infinity,
    client: {
      runInParent: true,
      args: ['--grep', config.grep],
    },
  });
};
