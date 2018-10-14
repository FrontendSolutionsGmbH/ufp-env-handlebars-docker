const Handlebars = require('handlebars')
const rainuEnvParser = require('rainu-env-parser')
const helpersHandlebars = require('handlebars-helpers');
// var helpersTemplate = require('template-helpers')();
const fs = require('fs')
const path = require('path')
const glob = require('glob')
const mkdirp = require('mkdirp')

console.log('HELPERS ARE',helpersHandlebars())
Handlebars.registerHelper(helpersHandlebars())
// Handlebars.registerHelper(helpersTemplate)
/**
 * one of the handlebars utility methods
 * after registering the ;default; helper you can use
 * {{default value defaultValue}}
 * in your templates
 *
 * */
Handlebars.registerHelper('default', function (value, defaultValue) {
    return new Handlebars.SafeString(value || defaultValue)
})

Handlebars.registerHelper('recure', function (template, value) {
    return new Handlebars.SafeString(template)
})

function line() {
    console.log('-------------------------------------------------------------------------------')
}
// Consts

const ufpConfig = rainuEnvParser.parse('UFP_', {
    templatedir: 'template',
    targetdir: 'public',
    prefix: 'CFG_',
    defaultfile: path.join(process.cwd(), 'config', 'default.json'),
    targetfile: path.join(process.cwd(), 'public', 'output.json')

})
// load the defaults
const defaults = {}//JSON.parse(fs.readFileSync(ufpConfig.defaultfile))

// Parse environment for object to feed to handlebars
const parsedEnv = {
    /**
     * wrap the input data into a template 'data' property
     */
    data: rainuEnvParser.parse(ufpConfig.prefix, defaults)
}

line()
console.log('Config Object is *:')
console.log(JSON.stringify(ufpConfig, null, ' '))
console.log('Notes:')
console.log('(** (use UFP_ prefix environment to override))')
line()
console.log('Env Object is * **:')
console.log(JSON.stringify(parsedEnv, null, ' '))
console.log('Notes:')
console.log('(* this is used as input for Handlebars)')
console.log('(** (use CFG_ prefix environment to override))')
line()

function handleFile(src, dest) {
    console.log(`Parsing ${src}`)
    const source = fs.readFileSync(src, 'utf8')
    var template = undefined
    var result = undefined
    try {

        template = Handlebars.compile(source)
        result = template(parsedEnv)
    } catch (e) {
        result = source + '\n-------------------UFP ENV HANDLEBARS PARSE ERROR ---------------\n' + e
        console.log(`Error parsing ${src}`)
        console.log(e)
    }

    if (!fs.existsSync(path.dirname(dest))) {
        console.log('Creating dir:', path.dirname(dest))
        mkdirp.sync(path.dirname(dest))
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
            line()
            console.log(`Writing data file ${ufpConfig.targetfile}`)
            if (!fs.existsSync(path.dirname(ufpConfig.targetfile))) {
                console.log('Creating dir:', path.dirname(ufpConfig.targetfile))
                mkdirp.sync(path.dirname(ufpConfig.targetfile))
            }
            fs.writeFileSync(ufpConfig.targetfile, JSON.stringify(parsedEnv))

        } else {
            console.log('Error', er)
        }
    })
