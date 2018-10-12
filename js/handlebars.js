const Handlebars = require('handlebars')
const rainuEnvParser = require('rainu-env-parser')
const fs = require('fs')
const path = require('path')
const glob = require("glob")
const defaults = require("./config/default.json")

// defs
Handlebars.registerHelper('default', function (value, defaultValue) {

    return new Handlebars.SafeString(value || defaultValue );
});

// Consts

const ufpConfig = rainuEnvParser.parse("UFP_", {

    templatedir: 'template',
    targetdir: 'public'
})
// Parse environment for object to feed to handlebars
const parsedEnv = rainuEnvParser.parse("CFG_", defaults)
console.log('Ufp Config is ', ufpConfig)
// console.log('Env Object is:')
// console.log(parsedEnv)

function handleFile(src, dest) {

    console.log(`Parsing ${src}`)
    const source = fs.readFileSync(src, 'utf8');
    var template = Handlebars.compile(source);

    var result = template(parsedEnv);
    if (!fs.existsSync(path.dirname(dest))) {
        console.log('Creating dir:', path.dirname(dest));
        fs.mkdirSync(path.dirname(dest));
    }
    fs.writeFileSync(dest, result)
    console.log(`Written ${dest}`)

}

const realPath1 = path.join(__dirname, ufpConfig.templatedir)
const realPath2 = path.join(__dirname, ufpConfig.targetdir)

console.log(`Output dir ${(realPath2)}`)

glob('**/**.*',
    {
        cwd: realPath1
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
                    handleFile(realPath1 + '/' + file, realPath2 + '/' + file)
                })
            }

        } else {
            console.log('Error', er)
        }
    })

