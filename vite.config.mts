import { defineConfig } from 'vite'
import ViteRails from 'vite-plugin-rails'
import { resolve } from 'path'

export default defineConfig({
  plugins: [
    ViteRails({
      fullReload: {
        additionalPaths: ['config/routes.rb', 'app/views/**/*']
      }
    }),
  ],
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
  }
})
