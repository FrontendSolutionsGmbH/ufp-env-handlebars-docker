const Handlebars = require('handlebars')
const rainuEnvParser = require('rainu-env-parser')

// removed because of npm audit issues
// const helpersHandlebars = require('handlebars-helpers')
// Handlebars.registerHelper(helpersHandlebars())

const childProcess = require('child_process')
const fs = require('fs')
const path = require('path')
const readChunk = require('read-chunk');
const fileType = require('file-type')
const glob = require('glob')
const mkdirp = require('mkdirp')

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

Handlebars.registerHelper('json', function (template, value) {
    return JSON.stringify(value,null,4)
})

function line() {
    console.log('-------------------------------------------------------------------------------')
}

// Consts
const ufpConfig = rainuEnvParser.parse('UFP_', {
    templatedir: 'static/template',
    targetdir: 'static/public',
    prefix: 'CFG_',
    defaultfile: path.join(process.cwd(), '/static/config', 'default.json'),
    targetfile: path.join(process.cwd(), '/static/public', 'output.json'),
    jsoncall: path.join(process.cwd(), '/static/config', 'getjsondata.sh')

})
// load the defaults
const defaults = JSON.parse(fs.readFileSync(ufpConfig.defaultfile))

// Parse environment for object to feed to handlebars
const parsedEnv = {
    /**
     * wrap the input data into a template 'data' property
     */
    data: rainuEnvParser.parse(ufpConfig.prefix, defaults)
}

// include a possible callback
if (fs.existsSync(ufpConfig.jsoncall)) {
    // callback file exists expect a full json output
    const callBackJson = childProcess.execSync(ufpConfig.jsoncall)
    console.log('JSON CALLBACK RETURNED', callBackJson.toString())

    try {
        const callbackData = JSON.parse(callBackJson)
        parsedEnv.data.callback = callbackData
    } catch (e) {
        console.log(`Callback error ${e}`)
    }
} else {
    console.log(`Callback file not found ${ufpConfig.jsoncall}`)
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
    src=path.resolve(src)
    dest=path.resolve(dest)
    console.log(`Parsing ${src}`)


    console.log('Determining file type')
    const buffer = readChunk.sync(src, 0, fileType.minimumBytes);
    const currentFileType= fileType(buffer)
   console.log('Filetype is ',currentFileType)
     if(currentFileType==null||(currentFileType&&currentFileType.mime==='text/html')) {
         console.log('Processing handlebars file')
         const source = fs.readFileSync(src, 'utf8')
         var template
         var result
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
     }else
         {
             console.log('Likely binary file detected, copying')
             if (!fs.existsSync(path.dirname(dest))) {
                 console.log('Creating dir:', path.dirname(dest))
                 mkdirp.sync(path.dirname(dest))
             }
             fs.copyFileSync(src,dest);

         }
}

const help1 = path.join(process.cwd(), ufpConfig.templatedir)
const help2 = path.join(process.cwd(), ufpConfig.targetdir)
console.log(`Template dir ${help1}`)
console.log(`Template dir ${(help2)}`)
line()
glob('**/**.*', {
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
