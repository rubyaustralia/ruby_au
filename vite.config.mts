import { defineConfig } from 'vite'
import ViteRails from 'vite-plugin-rails'
import { resolve } from 'path'

export default defineConfig({
  plugins: [
    ViteRails({
      fullReload: {
        additionalPaths: ['config/routes.rb', 'app/views/**/*']
      },
      stimulus: {
        hmr: true,
      }
    }),
  ],
  server: {
    host: 'localhost',
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
      '@images': resolve(__dirname, 'app/frontend/images'),
      '@': resolve(__dirname, 'app/frontend')
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
  build: {
    rollupOptions: {
      input: {
        application: './app/frontend/entrypoints/application.js',
        styles: './app/frontend/entrypoints/application.css'
      },
      external: ['jquery']
    },
    sourcemap: false,
  }

})
