const Handlebars = require('handlebars')
const rainuEnvParser = require('rainu-env-parser')
const fs = require('fs')
const path = require('path')
const glob = require("glob")
const mkdirp = require("mkdirp")
const defaults = JSON.parse(fs.readFileSync(path.join(process.cwd(), 'default.json')))

Handlebars.registerHelper('default', function (value, defaultValue) {
    return new Handlebars.SafeString(value || defaultValue);
});

function line() {
    console.log('-------------------------------------------------------------------------------')

}
// Consts

const ufpConfig = rainuEnvParser.parse("UFP_", {

    templatedir: 'template',
    targetdir: 'public',
    prefix: 'CFG_'

})

// Parse environment for object to feed to handlebars
const parsedEnv = rainuEnvParser.parse(ufpConfig.prefix, defaults)
line()
console.log('Config Object (use UFP_ prefix environment to override) is:')
console.log(JSON.stringify(ufpConfig, null, ' '))
line()
console.log('Env Object* (use CFG_ prefix environment to override) is:')
console.log(JSON.stringify(parsedEnv, null, ' '))
console.log('(* this is used as input for Handlebars)')
line()

function handleFile(src, dest) {

    console.log(`Parsing ${src}`)
    const source = fs.readFileSync(src, 'utf8');
    var template = Handlebars.compile(source);

    var result = template(parsedEnv);
    if (!fs.existsSync(path.dirname(dest))) {
        console.log('Creating dir:', path.dirname(dest));
        mkdirp.sync(path.dirname(dest));
    }
    fs.writeFileSync(dest, result)
    console.log(`Written ${dest}`)

}

const help1 = path.join(process.cwd(), ufpConfig.templatedir)
const help2 = path.join(process.cwd(), ufpConfig.targetdir)
console.log(`Template dir ${help1}`)
console.log(`Template dir ${(help2)}`)
line()

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

                console.log('Found handlebars templates', files.length)
                files.map(file => {
                    handleFile(help1 + '/' + file, help2 + '/' + file)
                })
            }

        } else {
            console.log('Error', er)
        }
    })
