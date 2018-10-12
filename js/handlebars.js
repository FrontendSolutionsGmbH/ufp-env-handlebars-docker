const Handlebars = require('handlebars')
const rainuEnvParser = require('rainu-env-parser')
const fs = require('fs')
const path = require('path')
const glob = require("glob")

// Consts

const templateDir = 'template'
const targetDir = 'public'

// Parse environment for object to feed to handlebars
const parsedEnv = rainuEnvParser.parse()
console.log('Env Object is:')
console.log(parsedEnv)

function handleFile(src, dest) {

    console.log(`Parsing ${src}->${dest}`)
    const source = fs.readFileSync(src, 'utf8');
    var template = Handlebars.compile(source);

    var result = template(parsedEnv);
    if (!fs.existsSync(path.dirname(dest))) {
        console.log('Creating dir:', path.dirname(dest));
        fs.mkdirSync(path.dirname(dest));
    }
    fs.writeFileSync(dest, result)

}

const help1 = path.join(__dirname, templateDir)
const help2 = path.join(__dirname, targetDir)
console.log(`Template dir ${help1}`)
console.log(`Template dir ${(help2)}`)
glob('**/**.*',
    {
        cwd: help1
    }, function (er, files) {
        // files is an array of filenames.
        // If the `nonull` option is set, and nothing
        // was found, then files is ["**/*.js"]
        // er is an error object or null.
        if (er === null) {

            if (files.length === 0) {
                console.log('No templates found')
            } else {

                console.log('Found handlebars templates', files)
                files.map(file => {
                    handleFile(help1 +'/'+ file, help2 + file)
                })
            }

        } else {
            console.log('Error', er)
        }
    })

