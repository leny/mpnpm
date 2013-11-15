/* mpnpm
 * https://github.com/leny/mpnpm
 *
 * COFFEE/JS Document - /lib/packages.js
 * package infos managment
 *
 * Copyright (c) 2013 Leny
 * Licensed under the MIT license.
*/

"use strict";

var config, fs, getPackage, request, root, sCachePath;

root = "" + __dirname + "/..";

request = require("request");

fs = require("fs");

config = require("" + root + "/../config.json");

sCachePath = "" + root + "/../" + config.cache.dir + "/packages/";

if (!fs.existsSync(sCachePath)) {
  fs.mkdirSync(sCachePath);
}

getPackage = function(oRequest, oResponse) {
  var sPackageCachePath;
  sPackageCachePath = "" + sCachePath + oRequest.params["package"] + ".json";
  if (fs.existsSync(sPackageCachePath)) {
    if ((fs.statSync(sPackageCachePath).mtime.getTime() + config.cache.ttl) > (new Date()).getTime()) {
      return oResponse.json(JSON.parse(fs.readFileSync(sPackageCachePath, {
        encoding: "utf-8"
      })));
    }
  }
  return request("" + config.npm.registry + "/" + oRequest.params["package"], function(oError, oRequestResponse) {
    var oPackage, oVersionInfos, sVersion, _ref;
    if (!oError && oRequestResponse.statusCode === 200) {
      oPackage = JSON.parse(oRequestResponse.body);
      _ref = oPackage.versions;
      for (sVersion in _ref) {
        oVersionInfos = _ref[sVersion];
        if (oVersionInfos.dist && oVersionInfos.dist.tarball) {
          oPackage.versions[sVersion].dist.tarball = oPackage.versions[sVersion].dist.tarball.replace(config.npm.registry, "http://localhost:" + config.server.port);
        }
      }
      fs.writeFileSync(sPackageCachePath, JSON.stringify(oPackage));
      return oResponse.json(oPackage);
    } else {
      return oResponse.send(oRequestResponse.statusCode || 404);
    }
  });
};

exports.init = function(oApp) {
  return oApp.get('/:package', getPackage);
};
