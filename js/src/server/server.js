const express = require('express')
const logger = require('morgan')
const path = require('path')
const app = express()

// consts

const PORT = 3000
const HOST = '0.0.0.0'

// log requests
app.use(logger('dev'))

// express on its own has no notion
// of a "file". The express.static()
// middleware checks for a file matching
// the `req.path` within the directory
// that you pass it. In this case "GET /js/app.js"
// will look for "./public/js/app.js".
app.use(express.static(path.join(process.cwd(), 'public')))

const server = app.listen(PORT)
console.log(`Started server on ${HOST}:${PORT}`)

// https://medium.com/@becintec/building-graceful-node-applications-in-docker-4d2cd4d5d392
// The signals we want to handle
// NOTE: although it is tempting, the SIGKILL signal (9) cannot be intercepted and handled
const signals = {
  'SIGHUP': 1,
  'SIGINT': 2,
  'SIGTERM': 15
}
// Do any necessary shutdown logic for our application here
const shutdown = (signal, value) => {
  console.log('shutdown!')
  server.close(() => {
    console.log(`server stopped by ${signal} with value ${value}`)
    process.exit(128 + value)
  })
}
// Create a listener for each of the signals that we want to handle
Object.keys(signals).forEach((signal) => {
  process.on(signal, () => {
    console.log(`process received a ${signal} signal`)
    shutdown(signal, signals[signal])
  })
})
