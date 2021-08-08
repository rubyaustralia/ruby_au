const { webpackConfig, merge } = require('@rails/webpacker')
const webpack = require('webpack')

const prependedConfig = {
  plugins: [
    new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery',
      jquery: 'jquery'
    })
  ]
}

const appendedConfig = {
  resolve: {
    extensions: ['.css', '.scss']
  }
}

module.exports = merge(prependedConfig, webpackConfig)
module.exports = merge(module.exports, appendedConfig)
