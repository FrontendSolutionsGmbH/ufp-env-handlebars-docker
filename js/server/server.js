/**
 * Module dependencies.
 */

var express = require('express');
var logger = require('morgan');
var path = require('path');
var app = express();

// consts

const PORT = 3000
const HOST = '0.0.0.0'

// log requests
app.use(logger('dev'));

// express on its own has no notion
// of a "file". The express.static()
// middleware checks for a file matching
// the `req.path` within the directory
// that you pass it. In this case "GET /js/app.js"
// will look for "./public/js/app.js".

app.use(express.static(path.join(process.cwd(), 'public')));

app.listen(PORT);
console.log(`Started server on ${HOST}:${PORT}`)
process.on('SIGTERM', function () {
    console.log(`SIGTERM`)
    app.close(function () {
        console.log(`Server Closed, exiting`)
        process.exit(0);
    });
});
