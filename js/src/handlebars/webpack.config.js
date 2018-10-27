const path = require('path')
console.log('Webpack config for handlebars part')

module.exports = {

  entry: path.join(__dirname, 'handlebars.js'),
  target: 'node',
  mode: 'production',
  output: {
    path: path.join(__dirname, '../../', 'dist/handlebars'),
    filename: 'index.js'
  },
  resolve: {
    alias: {
      handlebars: 'handlebars/dist/handlebars.js'
    }
  }
  // module: {
  //     rules: [
  //         {
  //             test: /\.js$/,
  //             loader: 'unlazy-loader'
  //         }
  //     ]
  // }
}
