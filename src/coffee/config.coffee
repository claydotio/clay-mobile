module.exports =
  API_URL:
    if process.env.MOCK
    then ''
    else process.env.API_URL or 'http://api.m.i.clay.io'
  APP_HOST: process.env.APP_HOST or 'clay.io'
  MOCK: process.env.MOCK or false
