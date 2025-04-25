module.exports = {
  content: [
    './app/views/**/*.{html,html.erb}',
    './app/helpers/**/*.rb',
    './app/frontend/**/*.{js,ts,css,scss}',
    './app/components/**/*.{html.erb,rb}',
  ],
  plugins: [
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
  ],
};
