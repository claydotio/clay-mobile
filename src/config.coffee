module.exports =
  CLAY_API_URL: process.env.CLAY_API_URL or 'https://clay.io/api/m/v1'
  FC_API_URL: process.env.FC_API_URL or 'https://clay.io/api/fc/v2'
  HOST: process.env.CLAY_MOBILE_HOST or 'clay.io'
  PORT: process.env.CLAY_MOBILE_PORT or process.env.PORT or 50040
  WEBPACK_DEV_HOSTNAME: process.env.WEBPACK_DEV_HOSTNAME or 'localhost'
  MOCK: process.env.MOCK or false
  ENV: process.env.NODE_ENV or 'production'
  ENVS:
    DEV: 'development'
    PROD: 'production'
    TEST: 'test'
