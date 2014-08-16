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
