# Clay Mobile

The beautiful frontend for [Clay.io](https://clay.io). Powered by [Zorium](https://zorium.org), CoffeeScript, Stylus, Gulp, webpack and sweat.

![Clay.io](https://raw.githubusercontent.com/claydotio/design-assets/master/images/desktop_site/devices.jpg)

### Getting Started
`npm install`
`npm run mock`

### Install pre-commit hook
`ln -s ../../pre-commit.sh .git/hooks/pre-commit`

### Commands
##### `npm run mock` - Start the debug server, stubbing API calls, watching files
##### `npm run dev` - Start the debug server, watching files
##### `npm test` - Run the test suite (opens Chrome and Firefox)

##### `npm start` - Start the debug server, serving from ./build

##### `NODE_ENV=production npm start` - Start the debug server, serving from ./dist

##### `npm run build` - Compiles + Minifies assets -> ./dist

### Dev Environment
##### Editor: Atom.io
> Plugins
  - Stylus
  - editorconfig
  - linter
  - linter-coffeelint

##### Google Chrome
> Plugins
  - [Kik Developer Tools](https://chrome.google.com/webstore/detail/kik-developer-tools/occbnccdhakfaomkhhdkmmknjbghmllm)
