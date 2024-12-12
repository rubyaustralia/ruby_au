module.exports = {
  plugins: [
    require('postcss-import'),
    require('tailwindcss')('./app/packs/src/tailwind.config.js'),
    require('autoprefixer'),
    require('postcss-flexbugs-fixes'),
    require('postcss-preset-env'),
  ]
}
