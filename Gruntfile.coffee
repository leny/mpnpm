"use strict"

module.exports = ( grunt ) ->

    require( "matchdep" ).filterDev( "grunt-*" ).forEach grunt.loadNpmTasks

    grunt.initConfig
        bumpup: "package.json"
        coffee:
            lib:
                expand: yes
                cwd: "src/"
                src: [ "**/*.coffee" ]
                dest: "bin/"
                ext: ".js"
                options:
                    bare: yes
            test:
                expand: yes
                cwd: "test/"
                src: [ "**/*.coffee" ]
                dest: "test/"
                ext: ".js"
                options:
                    bare: yes
        jshint:
            options:
                jshintrc: ".jshintrc"
            gruntfile:
                src: "Gruntfile.js"
            lib:
                src: [ "bin/**/*.js" ]
        nodemon:
            server:
                options:
                    file: "bin/server.js"
                    watchedExtensions: [ "js" ]
                    watchedFolders: [ "bin" ]
                    nodeArgs: [ "--debug" ]
        watch:
            lib:
                files: [
                    "src/**/*.coffee"
                ]
                options:
                    nospawn: yes
                tasks: [
                    "clear"
                    "coffee:lib"
                    "jshint:lib"
                    "bumpup:build"
                ]
        concurrent:
            dev:
                tasks: [ "nodemon", "watch:lib" ]
                options:
                    logConcurrentOutput: yes

    grunt.registerTask "default", [
        "coffee:lib"
        "jshint:lib"
        "bumpup:build"
    ]

    grunt.registerTask "work", [
        "clear"
        "concurrent:dev"
    ]
