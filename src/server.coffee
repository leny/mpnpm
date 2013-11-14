###
 * mpnpm
 * https://github.com/leny/mpnpm
 *
 * Copyright (c) 2013 Leny
 * Licensed under the MIT license.
###

"use strict"

http = require "http"

server = http.createServer()

server.on "request", ( oRequest, oResponse ) ->
    console.log oRequest.method, oRequest.url
    oResponse.end()

server.listen 8080, "localhost"
