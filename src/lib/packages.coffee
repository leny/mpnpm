### mpnpm
 * https://github.com/leny/mpnpm
 *
 * COFFEE/JS Document - /lib/packages.js
 * package infos managment
 *
 * Copyright (c) 2013 Leny
 * Licensed under the MIT license.
###

"use strict"

root = "#{ __dirname }/.."

request = require "request"
fs = require "fs"

config = require "#{ root }/../config.json"

sCachePath = "#{ root }/../#{ config.cache.dir }/packages/"

if not fs.existsSync sCachePath
    fs.mkdirSync sCachePath

getPackage = ( oRequest, oResponse ) ->
    sPackageCachePath = "#{ sCachePath }#{ oRequest.params.package }.json"
    if fs.existsSync sPackageCachePath
        if ( fs.statSync( sPackageCachePath ).mtime.getTime() + config.cache.ttl ) > ( new Date() ).getTime()
            return oResponse.json JSON.parse fs.readFileSync sPackageCachePath,
                encoding: "utf-8"
    request "#{ config.npm.registry }/#{ oRequest.params.package }", ( oError, oRequestResponse ) ->
        if not oError and oRequestResponse.statusCode is 200
            oPackage = JSON.parse oRequestResponse.body
            for sVersion, oVersionInfos of oPackage.versions
                if oVersionInfos.dist and oVersionInfos.dist.tarball
                    oPackage.versions[ sVersion ].dist.tarball = oPackage.versions[ sVersion ].dist.tarball.replace config.npm.registry, "http://localhost:#{ config.server.port }"
            fs.writeFileSync sPackageCachePath, JSON.stringify oPackage
            oResponse.json oPackage
        else
            oResponse.send oRequestResponse.statusCode or 404

exports.init = ( oApp ) ->
    oApp.get '/:package', getPackage
