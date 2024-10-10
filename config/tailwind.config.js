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
        color1: '#471215',
        color2: '#572418',
        color3: '#8a2e2c',
        color4: '#aa928c',
        color5: '#835d56',
        color6: '#c4cbcb',
        color7: '#596c57',
        color8: '#b96160',
        color9: '#b2b8b5',
        color10: '#183821',
        color11: '#1f201e',
        color12: '#1e1b1a',
        color13: '#1b1e2a',
        color14: '#ffecff',
        color15: '#ffcccc',
        color16: '#ffffff',
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
