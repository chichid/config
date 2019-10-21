import * as ts from 'typescript';
const path = require('path');
const { afs } = require('./util');

const compilerOptionsCache = {};
const transpiledContentCache = {};
const watchedDirectories = {};

export interface LoaderResult {
  content: string;
  hasChanged: boolean;
}

export async function load(basePath: string, filePath: string): Promise<LoaderResult> {
  const { content, hasChanged } = await transpileFile(basePath, filePath);

  return {
    content,
    hasChanged,
  };
}

async function transpileFile(basePath: string, filePath: string) {
  const projectPath = path.resolve(basePath);
  const fullPath = getFullPath(basePath, filePath); 
  let content = transpiledContentCache[fullPath];

  if (typeof content !== 'undefined') {
    return {
      content,
      hasChanged: false,
    };
  }

  const readBuffer = await afs.readFile(fullPath);
  const rawContent = readBuffer.toString();
  const compilerOptions = getCompilerOptions(basePath);

  content = ts.transpile(
    rawContent,
    compilerOptions
  );

  transpiledContentCache[fullPath] = content;

  const watchPath: string = compilerOptions.rootDir;
  if (!watchedDirectories[watchPath]) {
    watchedDirectories[watchPath] = true;

    afs.watchDir(watchPath, filename => {
      if (filename.indexOf('.ts') !== -1) {
	updateCachedContent(watchPath, filename, basePath);
      } 
    });
  }

  return {
    content,
    hasChanged: true,
  };
}

function updateCachedContent(watchPath: string, filename: string, basePath: string) {
  console.log(`[update cache] ${watchPath}/${filename}`);
  const fullPath = getFullPath(watchPath, filename);
  delete transpiledContentCache[fullPath];

  const filePath: string = fullPath.replace(basePath, '');
  transpileFile(basePath, filePath);
}


function getFullPath(basePath: string, filePath: string) {
  return path.resolve(basePath + '/' + filePath);
}

function getCompilerOptions(basePath: string): ts.CompilerOptions {
  if (compilerOptionsCache[basePath]) {
    return compilerOptionsCache[basePath];
  }

  const parseConfigHost: ts.ParseConfigHost = {
    fileExists: ts.sys.fileExists,
    readFile: ts.sys.readFile,
    readDirectory: ts.sys.readDirectory,
    useCaseSensitiveFileNames: true,
  };

  const configFileName = ts.findConfigFile(
    basePath,
    ts.sys.fileExists,
    "tsconfig.json"
  );

  const configFile = ts.readConfigFile(configFileName, ts.sys.readFile);

  const { options } = ts.parseJsonConfigFileContent(
    configFile.config,
    parseConfigHost,
    basePath
  );
  
  options.sourceMap = false; 

  compilerOptionsCache[basePath] = options;

  return options;
}

