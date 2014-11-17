# Clay Mobile

### Getting Started
`npm install`
`npm run dev`

### Install pre-commit hook
`ln -s ../../pre-commit.sh .git/hooks/pre-commit`

### Commands
##### `npm run dev` - Start the debug server, watching files
##### `npm test` - Run the test suite (opens Chrome and Firefox)

##### `npm start` - Start the debug server, serving from ./build

##### `NODE_ENV=production npm start` - Start the debug server, serving from ./dist

##### `npm run build` - Compiles + Minifies assets -> ./dist

#### Typical Dev Command
`API_PATH=http://192.168.0.100:3001 FLAK_CANNON_PATH=http://192.168.0.100:3002 HOST=192.168.0.100:3000 WEBPACK_DEV_HOSTNAME=192.168.0.100 npm run dev`

API_PATH is only if you're running [clay-mobile-api](https://github.com/claydotio/clay-mobile-api) locally. FLAK_CANNON_PATH is only if you're running [flak-cannon](https://github.com/claydotio/flak-cannon) locally. Replace 192.168.0.100 with your local IP. 

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
  - [fb-flo](https://chrome.google.com/webstore/detail/fb-flo/ahkfhobdidabddlalamkkiafpipdfchp?hl=en)
