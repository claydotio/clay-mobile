module.exports =
  API_PATH:
    if process.env.MOCK
    then ''
    else process.env.API_PATH or '/api/m/v1/'
  FLAK_CANNON_PATH: process.env.FLAK_CANNON_PATH or '/api/fc/v1'
  HOSTNAME: process.env.HOSTNAME or 'clay.io'
  MOCK: process.env.MOCK or false
  ENV: process.env.NODE_ENV or 'production'
  ENVS:
    DEV: 'development'
    PROD: 'production'
    TEST: 'test'
