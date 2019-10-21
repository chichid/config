const express = require('express');
const proxy = require('http-proxy-middleware');
const path = require('path');
const serveStatic = require('serve-static');
const { afs } = require('./util');
const { load: loadTs } = require('./ts-loader');

const FND_APPS_HOME = path.resolve(process.env.HOME + '/Projects/fnd-apps');
const FND_APPROVALS_HOME = FND_APPS_HOME + '/fnd-approvals';
const PORT = 8081;
const PROXY_PORT = 8082;

const SourceMap = {
  APPROVALS_CCA_ROOT: '/fnd-apps/node_modules/@oracle/fnd-approvals',
};

(function main() {
  const app = express();

  app.use(SourceMap.APPROVALS_CCA_ROOT + '/**/*.css', staticResourcesMiddleware);
  app.use(SourceMap.APPROVALS_CCA_ROOT + '/**/*.html', staticResourcesMiddleware);
  app.use(SourceMap.APPROVALS_CCA_ROOT + '/**/*.js', tsMiddleware); 
  app.use(proxy({ target: `http://localhost:${PROXY_PORT}`, changeOrigin: true }));

  console.log(`server is running at http://localhost:${PORT}`);
  app.listen(PORT);
})();

async function tsMiddleware(req, res, next) {
  try {
    const tsFilePath = getApprovalsResource(req.originalUrl).replace('.js','.ts');
    const fullPath = path.join(FND_APPROVALS_HOME, tsFilePath);
    const exists = await afs.exists(fullPath);

    if (exists) {
      console.log(`[ts-loader] loading ${tsFilePath}`);
      const { content, hasChanged } = await loadTs(FND_APPROVALS_HOME, tsFilePath);
      res.header('SourceMap', 'http://localhost:3000/' + req.originalUrl + '.map');
      res.end(content);
    } else {
      next();
    }
  } catch(e) {
    res.status(500);
    res.end(e.stack);
  }
}

async function staticResourcesMiddleware(req, res, next) {
  const resourcePath = getApprovalsResource(req.originalUrl);
  const fullPath = path.join(FND_APPROVALS_HOME, resourcePath);
  const exists = await afs.exists(fullPath);

  if (exists) {
    console.log(`[static-resource] serving ${fullPath}`)
    res.sendFile(fullPath);
  } else {
    next();
  }
}

function getApprovalsResource(originalUrl) {
   return '/src/' + originalUrl.replace(SourceMap.APPROVALS_CCA_ROOT, '');
}
