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

logger = require "#{ root }/lib/logger.js"

config = require "#{ root }/../config.json"

sCachePath = "#{ root }/../#{ config.cache.dir }/"

getPackage = ( oRequest, oResponse ) ->
    sPackageCacheFolder = "#{ sCachePath }/#{ oRequest.params.package }/"
    sPackageCachePath = "#{ sPackageCacheFolder }#{ oRequest.params.package }.json"
    if fs.existsSync sPackageCachePath
        if ( fs.statSync( sPackageCachePath ).mtime.getTime() + config.cache.ttl ) > ( new Date() ).getTime()
            logger "serve package #{ oRequest.params.package } from cache"
            return oResponse.json JSON.parse fs.readFileSync sPackageCachePath,
                encoding: "utf-8"
        else
            logger "cached package #{ oRequest.params.package } files are too old, deleted"
            for oFile in fs.readdirSync sPackageCacheFolder
                fs.unlinkSync "#{ sPackageCacheFolder }#{ oFile }"
            fs.rmdirSync sPackageCacheFolder
    request "#{ config.npm.registry }/#{ oRequest.params.package }", ( oError, oRequestResponse ) ->
        if not oError and oRequestResponse.statusCode is 200
            logger "serve package #{ oRequest.params.package } from registry"
            oPackage = JSON.parse oRequestResponse.body
            for sVersion, oVersionInfos of oPackage.versions
                if oVersionInfos.dist and oVersionInfos.dist.tarball
                    oPackage.versions[ sVersion ].dist.tarball = oPackage.versions[ sVersion ].dist.tarball.replace config.npm.registry, "http://localhost:#{ config.server.port }"
            if not fs.existsSync sPackageCachePath
                fs.mkdirSync sPackageCacheFolder
            fs.writeFileSync sPackageCachePath, JSON.stringify oPackage
            oResponse.json oPackage
        else
            logger "error when serving package #{ oRequest.params.package } from registry"
            oResponse.send oRequestResponse.statusCode or 404

exports.init = ( oApp ) ->
    oApp.get '/:package', getPackage
