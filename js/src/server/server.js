const express = require('express')
const logger = require('morgan')
const path = require('path')
const app = express()

// exception handlers

const PORT = 3000
const HOST = '0.0.0.0'

process.on('uncaughtException', function (err) {
    if (err.errno === 'EADDRINUSE') {
        console.log(`The port ${PORT} on local machine is already in use, please check for any other running node-express or any other server running on your local machine using port ${PORT}`)
    } else {
        console.log('Some other error: ', err)
    }
    process.exit(0)
})

// consts

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
