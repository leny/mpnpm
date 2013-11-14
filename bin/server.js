/*
 * mpnpm
 * https://github.com/leny/mpnpm
 *
 * Copyright (c) 2013 Leny
 * Licensed under the MIT license.
*/

"use strict";

var http, server;

http = require("http");

server = http.createServer();

server.on("request", function(oRequest, oResponse) {
  console.log(oRequest.method, oRequest.url);
  return oResponse.end();
});

server.listen(8080, "localhost");
