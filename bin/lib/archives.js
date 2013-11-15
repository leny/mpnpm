/* mpnpm
 * https://github.com/leny/mpnpm
 *
 * COFFEE/JS Document - /lib/archives.js
 * package archives managment
 *
 * Copyright (c) 2013 Leny
 * Licensed under the MIT license.
*/

"use strict";

var config, fs, getArchive, logger, request, root, sCachePath;

root = "" + __dirname + "/..";

request = require("request");

fs = require("fs");

logger = require("" + root + "/lib/logger.js");

config = require("" + root + "/../config.json");

sCachePath = "" + root + "/../" + config.cache.dir + "/";

getArchive = function(oRequest, oResponse) {
  var oArchiveFile, sArchiveCacheFolder, sArchiveCachePath;
  sArchiveCacheFolder = "" + sCachePath + oRequest.params["package"] + "/";
  sArchiveCachePath = "" + sArchiveCacheFolder + oRequest.params.archive;
  if (fs.existsSync(sArchiveCachePath)) {
    logger("serve archive " + oRequest.params.archive + " from cache");
    return oResponse.sendfile(oRequest.params.archive, {
      root: sArchiveCacheFolder
    });
  }
  logger("serve archive " + oRequest.params.archive + " from registry");
  oArchiveFile = fs.createWriteStream(sArchiveCachePath);
  request("" + config.npm.registry + "/" + oRequest.params["package"] + "/-/" + oRequest.params.archive).pipe(oArchiveFile);
  return oArchiveFile.on("finish", function() {
    oArchiveFile.close();
    try {
      JSON.parse(fs.readFileSync(sArchiveCachePath, {
        encoding: "utf-8"
      }));
    } catch (oError) {
      return oResponse.sendfile(oRequest.params.archive, {
        root: sArchiveCacheFolder
      });
    }
    return oResponse.send(404);
  });
};

exports.init = function(oApp) {
  return oApp.get('/:package/-/:archive', getArchive);
};
