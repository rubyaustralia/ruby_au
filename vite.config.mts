import { defineConfig } from 'vite'
import ViteRails from 'vite-plugin-rails'
import { resolve } from 'path'

export default defineConfig({
  plugins: [
    ViteRails({
      fullReload: {
        additionalPaths: [
          'config/routes.rb',
          'app/views/**/*',
          'sites/melbourne/app/views/**/*',
          'sites/melbourne/app/config/routes.rb',
        ]
      }
    }),
  ],
  resolve: {
    alias: {
      '@images': resolve(__dirname, 'app/frontend/images'),
      '@': resolve(__dirname, 'app/frontend'),
      '@37signals/lexxy/dist/stylesheets/lexxy.css': resolve(__dirname, 'node_modules/@37signals/lexxy/dist/stylesheets/lexxy.css')
    },
    dedupe: ['lucide']
  },
  css: {
    devSourcemap: true,
    preprocessorOptions: {
      scss: {
        quietDeps: true
      }
    }
  },
  test: {
    environment: 'jsdom',
    include: ['spec/javascript/**/*.spec.js', 'spec/javascript/**/*.test.js'],
    globals: true,
    root: '.'
  }
})
