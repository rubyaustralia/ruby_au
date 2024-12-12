module.exports = {
  purge: [],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      // Create your own at: https://javisperez.github.io/tailwindcolorshades
      colors: {
        "title-copy": "#101010",
        "text-grey-darkest": "#404040",
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
  ],
}
