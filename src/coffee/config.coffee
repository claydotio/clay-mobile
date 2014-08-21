module.exports =
  API_URL: if process.env.MOCK then '' else process.env.API_URL or ''
  APP_HOST: process.env.APP_HOST or ''
  MOCK: process.env.MOCK or false
