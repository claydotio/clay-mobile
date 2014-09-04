module.exports =
  API_PATH:
    if process.env.MOCK
    then ''
    else process.env.API_PATH or '/api/v2'
  HOSTNAME: process.env.HOSTNAME or 'clay.io'
  MOCK: process.env.MOCK or false
  ENV: process.env.NODE_ENV or 'production'
  ENVS:
    DEV: 'development'
    PROD: 'production'
    TEST: 'test'
