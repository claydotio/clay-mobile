module.exports =
  API_PATH:
    if process.env.MOCK or process.env.NODE_ENV is 'test'
    then ''
    else process.env.API_PATH or '/api/m/v1'
  FLAK_CANNON_PATH:
    if process.env.MOCK or process.env.NODE_ENV is 'test'
    then ''
    else process.env.FLAK_CANNON_PATH or '/api/fc/v2'
  HOST: process.env.HOST or 'clay.io'
  MOCK: process.env.MOCK or false
  ENV: process.env.NODE_ENV or 'production'
  ENVS:
    DEV: 'development'
    PROD: 'production'
    TEST: 'test'
