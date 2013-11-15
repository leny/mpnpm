### mpnpm
 * https://github.com/leny/mpnpm
 *
 * COFFEE/JS Document - /server.js
 * main entry point, server set up
 *
 * Copyright (c) 2013 Leny
 * Licensed under the MIT license.
###

"use strict"

root = "#{ __dirname }"

fs = require "fs"

express = require "express"
app = express()

config = require "#{ root }/../config.json"

sCachePath = "#{ root }/../#{ config.cache.dir }/"

if not fs.existsSync sCachePath
    fs.mkdirSync sCachePath

require( "#{ root }/lib/packages.js" ).init app
require( "#{ root }/lib/archives.js" ).init app

app.listen config.server.port
