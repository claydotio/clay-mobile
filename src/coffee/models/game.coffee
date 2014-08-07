resource = require '../lib/resource'

module.exports = resource.setBaseUrl('/api/v2').all('games')
