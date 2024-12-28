import { defineConfig } from 'vite'
import ViteRails from 'vite-plugin-rails'
import { resolve } from 'path'

export default defineConfig({
  plugins: [
    ViteRails(
      ['config/routes.rb', 'app/views/**/*'],
      { delay: 200 },
    ),
  ],
  server: {
    host: 'localhost', // Match the Vite dev server host
    port: 3036,
    strictPort: true,
    watch: {
      ignored: ['**/node_modules/**'],
    },
    headers: {
      'Access-Control-Allow-Origin': '*',
    },
  },
  resolve: {
    alias: {
      '@': resolve(__dirname, 'app/javascript')
    }
  },
  css: {
    devSourcemap: true,
    preprocessorOptions: {
      scss: {
        quietDeps: true
      }
    }
  },
  build: {
    rollupOptions: {
      external: ['jquery']
    }
  }
})