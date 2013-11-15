### mpnpm
 * https://github.com/leny/mpnpm
 *
 * COFFEE/JS Document - /lib/logger.js
 * simple conditionnal logger
 *
 * Copyright (c) 2013 Leny
 * Licensed under the MIT license.
###

"use strict"

root = "#{ __dirname }/.."

config = require "#{ root }/../config.json"

exports = module.exports = ( mData ) ->
    if config.server.log
        console.log mData
