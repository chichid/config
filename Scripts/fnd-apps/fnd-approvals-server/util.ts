const fs = require('fs');
const { promisify } = require('util');

export const afs = {
	readFile: promisify(fs.readFile),
	exists: promisify(fs.exists),
  watchDir,
};

export interface WatchDirOptions {
  eventType: string;
}

function watchDir(baseFolder: string, callback: (string, WatchDirOptions) => void) {
  fs.watch(baseFolder, { recursive: true }, (eventType, filename) => {
    callback(filename, { eventType });
  });
}
