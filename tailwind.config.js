module.exports = {
  purge: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/frontend/**/*.{js,ts}',
  ],
  darkMode: false,
  theme: {
    extend: {
      colors: {
        'transparent': 'transparent',

        /* RubyAU Custom colours generated via https://javisperez.github.io/tailwindcolorshades/ */
        'pink-darkest' : '#4A051E',
        'pink-darker' : '#940B3C',
        'pink-dark' : '#DE105A',
        'pink' : '#F71264',
        'pink-light' : '#F95993',
        'pink-lighter' : '#FCA0C1',
        'pink-lightest' : '#FEE7F0',

        'purple-darkest' : '#241146',
        'purple-darker' : '#49238C',
        'purple-dark' : '#6D34D2',
        'purple' : '#793AE9',
        'purple-light' : '#A175F0',
        'purple-lighter' : '#C9B0F6',
        'purple-lightest' : '#F2EBFD',

        'cyan-darkest' : '#164844',
        'cyan-darker' : '#2C9189',
        'cyan-dark' : '#42D9CD',
        'cyan' : '#49F1E4',
        'cyan-light' : '#80F5EC',
        'cyan-lighter' : '#B6F9F4',
        'cyan-lightest' : '#EDFEFC',
        /* END RubyAU Custom colours */

        'black': '#22292f',
        'grey-darkest': '#3d4852',
        'grey-darker': '#606f7b',
        'grey-dark': '#8795a1',
        'grey': '#b8c2cc',
        'grey-light': '#dae1e7',
        'grey-lighter': '#f1f5f8',
        'grey-lightest': '#f8fafc',
        'white': '#ffffff',

        'red-darkest': '#3b0d0c',
        'red-darker': '#621b18',
        'red-dark': '#cc1f1a',
        'red': '#e3342f',
        'red-light': '#ef5753',
        'red-lighter': '#f9acaa',
        'red-lightest': '#fcebea',

        'orange-darkest': '#462a16',
        'orange-darker': '#613b1f',
        'orange-dark': '#de751f',
        'orange': '#f6993f',
        'orange-light': '#faad63',
        'orange-lighter': '#fcd9b6',
        'orange-lightest': '#fff5eb',

        'yellow-darkest': '#453411',
        'yellow-darker': '#684f1d',
        'yellow-dark': '#f2d024',
        'yellow': '#ffed4a',
        'yellow-light': '#fff382',
        'yellow-lighter': '#fff9c2',
        'yellow-lightest': '#fcfbeb',

        'green-darkest': '#0f2f21',
        'green-darker': '#1a4731',
        'green-dark': '#1f9d55',
        'green': '#38c172',
        'green-light': '#51d88a',
        'green-lighter': '#a2f5bf',
        'green-lightest': '#e3fcec',

        'teal-darkest': '#0d3331',
        'teal-darker': '#20504f',
        'teal-dark': '#38a89d',
        'teal': '#4dc0b5',
        'teal-light': '#64d5ca',
        'teal-lighter': '#a0f0ed',
        'teal-lightest': '#e8fffe',

        'blue-darkest': '#12283a',
        'blue-darker': '#1c3d5a',
        'blue-dark': '#2779bd',
        'blue': '#3490dc',
        'blue-light': '#6cb2eb',
        'blue-lighter': '#bcdefa',
        'blue-lightest': '#eff8ff',

        'indigo-darkest': '#191e38',
        'indigo-darker': '#2f365f',
        'indigo-dark': '#5661b3',
        'indigo': '#6574cd',
        'indigo-light': '#7886d7',
        'indigo-lighter': '#b2b7ff',
        'indigo-lightest': '#e6e8ff',

        pink: {
          DEFAULT: '#ec4899',
          lighter: '#fce7f3',
          light: '#f9a8d4',
          dark: '#be185d',
          darker: '#9d174d',
          darkest: '#831843'
        },
        grey: {
          lighter: '#f3f4f6',
          darkest: '#111827'
        },
        purple: {
          DEFAULT: '#7c3aed',
          darker: '#5b21b6'
        },
        cyan: {
          DEFAULT: '#06b6d4'
        },
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
