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

var config, fs, getLastPackage, getPackage, getVersionnedPackage, logger, request, root, sCachePath;

root = "" + __dirname + "/..";

request = require("request");

fs = require("fs");

logger = require("" + root + "/lib/logger.js");

config = require("" + root + "/../config.json");

sCachePath = "" + root + "/../" + config.cache.dir + "/";

getPackage = function(sPackageName, sPackageRegistryURL, oRequest, oResponse) {
  var oFile, sPackageCacheFolder, sPackageCachePath, _i, _len, _ref;
  sPackageCacheFolder = "" + sCachePath + sPackageName + "/";
  sPackageCachePath = "" + sPackageCacheFolder + sPackageName + ".json";
  if (fs.existsSync(sPackageCachePath)) {
    if ((fs.statSync(sPackageCachePath).mtime.getTime() + config.cache.ttl) > (new Date()).getTime()) {
      logger("serve package " + sPackageName + " from cache");
      return oResponse.json(JSON.parse(fs.readFileSync(sPackageCachePath, {
        encoding: "utf-8"
      })));
    } else {
      logger("cached package " + sPackageName + " files are too old, deleted");
      _ref = fs.readdirSync(sPackageCacheFolder);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        oFile = _ref[_i];
        fs.unlinkSync("" + sPackageCacheFolder + oFile);
      }
      fs.rmdirSync(sPackageCacheFolder);
    }
  }
  return request(sPackageRegistryURL, function(oError, oRequestResponse) {
    var oPackage, oVersionInfos, sVersion, _ref1;
    if (!oError && oRequestResponse.statusCode === 200) {
      logger("serve package " + sPackageName + " from registry");
      oPackage = JSON.parse(oRequestResponse.body);
      _ref1 = oPackage.versions;
      for (sVersion in _ref1) {
        oVersionInfos = _ref1[sVersion];
        if (oVersionInfos.dist && oVersionInfos.dist.tarball) {
          oPackage.versions[sVersion].dist.tarball = oPackage.versions[sVersion].dist.tarball.replace(config.npm.registry, config.server.url);
        }
      }
      if (!fs.existsSync(sPackageCacheFolder)) {
        fs.mkdirSync(sPackageCacheFolder);
      }
      fs.writeFileSync(sPackageCachePath, JSON.stringify(oPackage));
      return oResponse.json(oPackage);
    } else {
      logger("error when serving package " + sPackageName + " from registry");
      return oResponse.send(oRequestResponse.statusCode || 404);
    }
  });
};

getLastPackage = function(oRequest, oResponse) {
  var sPackageName, sPackageRegistryURL;
  sPackageName = oRequest.params["package"];
  sPackageRegistryURL = "" + config.npm.registry + "/" + sPackageName;
  return getPackage(sPackageName, sPackageRegistryURL, oRequest, oResponse);
};

getVersionnedPackage = function(oRequest, oResponse) {
  var sPackageName, sPackageRegistryURL;
  sPackageName = "" + oRequest.params["package"] + "-" + oRequest.params.version;
  sPackageRegistryURL = "" + config.npm.registry + "/" + oRequest.params["package"] + "/" + oRequest.params.version;
  return getPackage(sPackageName, sPackageRegistryURL, oRequest, oResponse);
};

exports.init = function(oApp) {
  oApp.get("/:package", getLastPackage);
  return oApp.get("/:package/:version", getVersionnedPackage);
};
