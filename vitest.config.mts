import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    environment: 'jsdom',
    include: [
      'spec/javascript/**/*.spec.js', 
      'spec/javascript/**/*.test.js',
      'app/frontend/__tests__/**/*.test.js',
      'app/frontend/**/*.test.js'
    ],
    globals: true,
    root: '.'
  }
})
