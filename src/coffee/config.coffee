module.exports =
  API_URL:
    if process.env.MOCK
    then ''
    else process.env.API_URL or 'http://clay.io/api/v2'
  HOSTNAME: process.env.HOSTNAME or 'clay.io'
  MOCK: process.env.MOCK or false
