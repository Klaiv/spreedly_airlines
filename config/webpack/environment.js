const { environment } = require('@rails/webpacker')
const webpack = require("webpack") 

environment.plugins.append("Provide", new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  Popper: ['@popperjs/core@2.9.2', 'default']
}))

module.exports = environment
