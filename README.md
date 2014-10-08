# mpnpm 

> My Personal NPM (NPM Lazy Mirror)

* * *

## Warning : this plugin is not maintained anymore

* * *

**mpnpm** is a lazy local mirror/cache for npm.

**mpnpm** is a reinterpretation of the [npm_lazy package from mixu](https://github.com/mixu/npm_lazy).

## How it works ?

**mpnpm** caches metadata & packages where you install it. By default, metadatas & packages are cached for 1 hour. You can change this in the config.

## Getting Started

`Clone this repo` or do an `npm install mpnpm`

Modify the file `config.json` at the root of mpnpm (see Documentation below), then launch the server with `node bin/server.js`

### Pointing your npm to mpnpm

#### Temporarily

	npm --registry http://localhost:54321 install package
	
#### Permanently

	npm config set registry http://localhost:54321
	
or add/modify this line in your config file `~/.npmrc` :

	registry = http://localhost:54321
	
**Need more help ?** Type `npm help config` or `npm help registry`

## Documentation

**/config.json**

```javascript
{
    "npm": {
        "registry": "http://registry.npmjs.org"
    },
    "cache": {
        "dir": ".mpnpm",
        "ttl": 3600000
    },
    "server": {
        "log": true,
        "port": 54321,
        "url": "http://localhost:54321"
    }
}
```

* **npm.registry** is the url of the npm registry which will be called for downloading metadata & packages
* **cache.dir** is the name of the directory where will be stored the cached data
* **cache.ttl** is *time to live* duration of the data in the cache, in milliseconds. By default, the value is one hour (3600000ms).
* **server.log** is a boolean to (un)activate logging on the server
* **server.port** is the port of listening for the node server
* **server.url** is the cache registry url you will call with npm

## Contributing

In lieu of a formal styleguide, take care to maintain the existing coding style. Lint your code using [Grunt](http://gruntjs.com/).

## Release History

* **2013/11/15 :** v1.0.0

## TODO

Writing unit tests :) 

## License

Copyright (c) 2013 Leny  
Licensed under the MIT license.
