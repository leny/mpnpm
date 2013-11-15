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

getPackage = ( sPackageName, sPackageRegistryURL, oRequest, oResponse ) ->
    sPackageCacheFolder = "#{ sCachePath }#{ sPackageName }/"
    sPackageCachePath = "#{ sPackageCacheFolder }#{ sPackageName }.json"
    if fs.existsSync sPackageCachePath
        if ( fs.statSync( sPackageCachePath ).mtime.getTime() + config.cache.ttl ) > ( new Date() ).getTime()
            logger "serve package #{ sPackageName } from cache"
            return oResponse.json JSON.parse fs.readFileSync sPackageCachePath,
                encoding: "utf-8"
        else
            logger "cached package #{ sPackageName } files are too old, deleted"
            for oFile in fs.readdirSync sPackageCacheFolder
                fs.unlinkSync "#{ sPackageCacheFolder }#{ oFile }"
            fs.rmdirSync sPackageCacheFolder
    request sPackageRegistryURL, ( oError, oRequestResponse ) ->
        if not oError and oRequestResponse.statusCode is 200
            logger "serve package #{ sPackageName } from registry"
            oPackage = JSON.parse oRequestResponse.body
            for sVersion, oVersionInfos of oPackage.versions
                if oVersionInfos.dist and oVersionInfos.dist.tarball
                    oPackage.versions[ sVersion ].dist.tarball = oPackage.versions[ sVersion ].dist.tarball.replace config.npm.registry, "http://localhost:#{ config.server.port }"
            if not fs.existsSync sPackageCacheFolder
                fs.mkdirSync sPackageCacheFolder
            fs.writeFileSync sPackageCachePath, JSON.stringify oPackage
            oResponse.json oPackage
        else
            logger "error when serving package #{ sPackageName } from registry"
            oResponse.send oRequestResponse.statusCode or 404

getLastPackage = ( oRequest, oResponse ) ->
    sPackageName = oRequest.params.package
    sPackageRegistryURL = "#{ config.npm.registry }/#{ sPackageName }"
    getPackage( sPackageName, sPackageRegistryURL, oRequest, oResponse )

getVersionnedPackage = ( oRequest, oResponse ) ->
    sPackageName = "#{ oRequest.params.package }-#{ oRequest.params.version }"
    sPackageRegistryURL = "#{ config.npm.registry }/#{ oRequest.params.package }/#{ oRequest.params.version }"
    getPackage( sPackageName, sPackageRegistryURL, oRequest, oResponse )

exports.init = ( oApp ) ->
    oApp.get "/:package", getLastPackage
    oApp.get "/:package/:version", getVersionnedPackage
