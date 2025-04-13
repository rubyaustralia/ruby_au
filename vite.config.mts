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
      '@': resolve(__dirname, 'app/frontend')
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
    },
    sourcemap: false,
  }
})
