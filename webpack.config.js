'use strict';

const { execSync } = require('child_process');
const os = require('os');

const getSpagoSources = function() {
  return execSync('spago sources').toString().split(os.EOL).filter(a => a.length > 3)
}

const spagoSources = getSpagoSources()

module.exports = {
  entry: './src/App',

  devtool: 'cheap-module-inline-source-map',

  devServer: {
    contentBase: '.',
    port: 4008,
    stats: 'errors-only'
  },

  output: {
    path: __dirname,
    pathinfo: true,
    filename: 'bundle.js'
  },

  module: {
    rules: [
      {
        test: /\.purs$/,
        exclude: /node_modules/,
        loader: 'purs-loader',
        options: {
          src: [
            ...spagoSources,
            'src/**/*.purs'
          ],
          pscIde: true
        }
      }
    ]
  },

  resolve: {
    modules: [
      'node_modules',
      'bower_components'
    ],

    extensions: [
      '.purs',
      '.js'
    ]
  }
};
