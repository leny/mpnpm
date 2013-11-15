### mpnpm
 * https://github.com/leny/mpnpm
 *
 * COFFEE/JS Document - /server.js
 *
 * Copyright (c) 2013 Leny
 * Licensed under the MIT license.
###

"use strict"

http = require "http"
root = "#{ __dirname }"


app = express()

config = require "#{ root }/../config.json"

sCachePath = "#{ root }/../#{ config.cache.dir }/"

if not fs.existsSync sCachePath
    fs.mkdirSync sCachePath

    console.log oRequest.method, oRequest.url
require( "#{ root }/lib/packages.js" ).init app

app.listen config.server.port
