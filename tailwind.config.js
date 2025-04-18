module.exports = {
  content: [
    './app/views/**/*.{html,html.erb}',
    './app/helpers/**/*.rb',
    './app/frontend/**/*.{js,ts,css,scss}',
    './app/components/**/*.{html.erb,rb}',
  ],
  theme: {
    extend: {
      colors: {
        transparent: 'transparent',
        pearl: '#F0F0F0',
        red: '#D30001',
        'red-dark': '#900000',
        'red-darker': '#700000',
      },
    },
  },
  plugins: [
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/forms'),
    require('@tailwindcss/line-clamp'),
    require('@tailwindcss/typography'),
  ],
};
