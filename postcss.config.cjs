module.exports = {
  plugins: [
    require('postcss-flexbugs-fixes'),
    require('@tailwindcss/postcss'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009'
      },
      stage: 3
    }),
    require('autoprefixer')
  ]
}