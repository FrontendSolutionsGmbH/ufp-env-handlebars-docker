const Handlebars = require('handlebars')
const rainuEnvParser = require('rainu-env-parser')
var fs = require('fs');

const templateFilename = 'template/index.html'
const targetDir = 'public'

try {
    var data = fs.readFileSync(templateFilename, 'utf8');
    console.log(data);

    var source = data;

    var template = Handlebars.compile(source);

    var parsed = rainuEnvParser.parse()
    console.log('Env Object is:')
    console.log(parsed)


    var result = template(parsed);
    console.log('--->', result)
    if (!fs.existsSync(targetDir)) {
        console.log('Creating dir:', targetDir);
        fs.mkdirSync(targetDir);
    }
    fs.writeFileSync(targetDir + '/index.html', result)
} catch (e) {
    console.log('Error:', e.stack);
}
