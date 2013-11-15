/* mpnpm
 * https://github.com/leny/mpnpm
 *
 * COFFEE/JS Document - /lib/logger.js
 * simple conditionnal logger
 *
 * Copyright (c) 2013 Leny
 * Licensed under the MIT license.
*/

"use strict";

var config, exports, root;

root = "" + __dirname + "/..";

config = require("" + root + "/../config.json");

exports = module.exports = function(mData) {
  if (config.server.log) {
    return console.log(mData);
  }
};
