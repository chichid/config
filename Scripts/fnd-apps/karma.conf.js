// Karma configuration
// Generated on Sat Oct 21 2017 12:58:07 GMT+0530 (India Standard Time)

// const ChromiumRevision = require('puppeteer/package.json').puppeteer.chromium_revision;
// const Downloader = require('puppeteer/utils/ChromiumDownloader');
// const revisionInfo = Downloader.revisionInfo(Downloader.currentPlatform(), ChromiumRevision);

// process.env.CHROME_BIN = revisionInfo.executablePath;

const path = require('path');
const process = require('process');

// process.env.CHROME_BIN = require('puppeteer').executablePath();

module.exports = function (config) {
  config.set({
    // base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: '',

    // frameworks to use
    // available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ['requirejs', 'qunit', 'fixture', 'karma-typescript'],

    plugins: [
      'karma-requirejs',
      'karma-qunit',
      'karma-chrome-launcher',
      'karma-firefox-launcher',
      'karma-webdriver-launcher',
      'karma-fixture',
      'karma-scss-preprocessor',
      'karma-typescript',
      'karma-mocha-reporter',
    ],

    proxies: {
      // Proxy for translations
      '/resources/translations/nls/': '/absolute' + path.resolve('webApps/fnd-apps/resources/translations/nls/'),
    },

    // list of files / patterns to load in the browser
    files: [
      'https://static.oracle.com/cdn/jet/v7.1.0/default/js/bundles-config.js',
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
      },
      {
        pattern: 'node_modules/**/*.*',
        included: false,
      },
      {
        pattern: 'src/**/*.*',
        included: false,
      },
      {
        pattern: 'tests/js/jet-composites/**/*.*',
        included: false,
      },
      {
        pattern: 'tests/qunit-test-utils.js',
        included: false,
      },
    ],

    // list of files to exclude
    exclude: ['src/js/jet-composites/@types/*',
      'src/**/*.spec.ts'],

    // preprocess matching files before serving them to the browser
    // available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {
      'src/js/jet-composites/**/*.ts': ['karma-typescript'],
      'src/js/jet-composites/**/*.scss': ['scss'],
    },

    karmaTypescriptConfig: {
      tsconfig: './tsconfig.json',
      bundlerOptions: {
        addNodeGlobals: false,
      },
      sourceMap: true,
      target: 'ES5',
      module: 'amd',
      reports: {
        lcovonly: {
          directory: 'fnd-approvals/reports/unit-tests',
          filename: 'lcov.info',
          subdirectory: 'lcov-report',
        },
        html: {
          directory: 'fnd-approvals/reports/unit-tests',
        },
      },
      coverageOptions: {
        instrumentation: true,
        instrumenterOptions: {
          preserveComments: true,
        },
        exclude: /\.(d|spec|test|strings|demo)\.ts/i,
        threshold: {
          global: {
            statements: 70,
            branches: 50,
            functions: 70,
            lines: 70,
          },
        },
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
    reporters: ['mocha', 'karma-typescript'],

    hostname: 'localhost',
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

    // retryLimit: 3,
    captureTimeout: 30000,
    browserDisconnectTimeout: 120000,
    // browserDisconnectTolerance: 3,
    browserNoActivityTimeout: 120000,

    // Concurrency level
    // how many browser should be started simultaneous
    concurrency: Infinity,
  });
};

