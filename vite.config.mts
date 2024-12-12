import { defineConfig } from 'vite'
import ViteRails from 'vite-plugin-rails'

export default defineConfig({
  plugins: [
    ViteRails({
      fullReload: ['config/routes.rb', 'app/views/**/*'],
    }),
  ],
  css: {
    postcss: './app/packs/postcss.config.js',
  },
})
