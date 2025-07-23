import js from '@eslint/js'

export default [
  js.configs.recommended,
  {
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: 'module',
      globals: {
        // Browser globals
        window: 'readonly',
        document: 'readonly',
        console: 'readonly',
        alert: 'readonly',
        confirm: 'readonly',
        setTimeout: 'readonly',
        clearTimeout: 'readonly',
        setInterval: 'readonly',
        clearInterval: 'readonly',
        requestAnimationFrame: 'readonly',
        fetch: 'readonly',
        // jQuery
        $: 'readonly',
        // Vitest globals
        describe: 'readonly',
        it: 'readonly',
        expect: 'readonly',
        beforeEach: 'readonly',
        afterEach: 'readonly',
        beforeAll: 'readonly',
        afterAll: 'readonly',
        vi: 'readonly'
      }
    },
    files: ['**/*.js', '**/*.mjs'],
    rules: {
      // Add any custom rules here
    }
  },
  {
    // Specific config for CommonJS files (like config files)
    files: ['tailwind.config.js', 'postcss.config.js'],
    languageOptions: {
      sourceType: 'commonjs',
      globals: {
        module: 'readonly',
        require: 'readonly',
        exports: 'readonly',
        __dirname: 'readonly',
        __filename: 'readonly',
        process: 'readonly'
      }
    }
  },
  {
    // Specific config for legacy files that use require()
    files: ['app/frontend/entrypoints/2019_survey.js'],
    languageOptions: {
      sourceType: 'commonjs',
      globals: {
        require: 'readonly',
        $: 'readonly'
      }
    },
    rules: {
      'no-redeclare': 'off'
    }
  },
  {
    // Specific config for test files
    files: ['spec/**/*.js', '**/*.test.js', '**/*.spec.js'],
    rules: {
      // Allow console.log in tests
      'no-console': 'off'
    }
  }
]
