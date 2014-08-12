module.exports =
  API_URL: if process.env.MOCK then '' else process.env.API_URL or ''
