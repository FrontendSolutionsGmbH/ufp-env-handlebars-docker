#!/usr/bin/env node
const childProcess = require('child_process')
const path=require('path')

function log(message) {
    console.log(`${new Date().toLocaleDateString()} ${message}`)
}

log(" _______ _______ ______                              _______ _______ ___ ___  ")
log("|   |   |    ___|   __ \\         ______             |    ___|    |  |   |   | ")
log("|   |   |    ___|    __/        |______|            |    ___|       |   |   | ")
log("|_______|___|   |___|                               |_______|__|____|\\_____/  ")
log("                                                                              ")
log(" _______ _______ _______ _____  _____   _______ ______ _______ ______ _______ ")
log("|   |   |   _   |    |  |     \\|     |_|    ___|   __ \\   _   |   __ \\     __|")
log("|       |       |       |  --  |       |    ___|   __ <       |      <__     |")
log("|___|___|___|___|__|____|_____/|_______|_______|______/___|___|___|__|_______|")
log("")

log("-------------------------------------------------------------------------------")
log("Executing Handlebars Render pass")
log("-------------------------------------------------------------------------------")
childProcess.execSync(`node src/handlebars/handlebars.js`, {stdio: [0, 1, 2]});
// node  src / handlebars / handlebars.js
log("-------------------------------------------------------------------------------")
log("Starting Server")
log("-------------------------------------------------------------------------------")
// node src / server / server.js
const childProcessServer = childProcess.spawn(`node`,[`src/server/server.js`], {
    cwd: process.cwd(),
    stdio: [0, 1, 2]
});
console.log(`Starting directory: ${process.cwd()}`);
log('Process is ', childProcessServer)
process.on('SIGTERM', () => {
    console.info('SIGTERM signal received.');
    console.log('Closing...');
    childProcessServer.kill('SIGINT')

});

childProcessServer.on('exit', function (code, signal) {
    console.log('child process exited with ' +
        `code ${code} and signal ${signal}`);
});
childProcessServer.on('error', function (code ) {
    console.log('child process onError with ' +
        `code ${code}  `);
});
