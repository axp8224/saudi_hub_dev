const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './node_modules/flowbite/**/*.js'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        color1: '#471815',
        color2: '#572824',
        color3: '#ae928c',
        color4: '#835d56',
        color5: '#bbc2b8',
        color6: '#596c57',
        color7: '#2d4830',
        color8: '#183820',
        color9: '#173821',
        color10: '#121623',
        color11: '#1b1e2a',
        color12: '#111635',
        color13: '#282935',
        color14: '#bfbdbd',
        color15: '#dbdad9',
        color16: '#fffeff',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
    require('flowbite/plugin')
  ]
}
