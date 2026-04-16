source 'https://rubygems.org'
ruby file: '.ruby-version'
gem 'rails', '>= 8.0.0'
gem 'pg'
gem 'puma'

gem 'ahoy_matey' # analytics
gem 'bcrypt'
gem 'bugsnag'
gem 'createsend'
gem 'decent_exposure'
gem 'devise'
gem 'devise-multi_email', github: 'rubyaustralia/devise-multi_email', branch: 'main'
gem 'friendly_id', '>= 5.5'
gem 'geocoder' # geolocation for ahoy
gem 'herb'
gem 'icalendar'
gem 'image_processing', '~> 1.13'
gem 'inline_svg', '~> 1.10.0'
gem 'jbuilder'
gem 'kaminari'
gem 'lexxy'
gem 'meta-tags'
gem 'premailer-rails'
gem 'pygmentize'
gem 'rails_12factor'
gem 'redcarpet'
gem 'solid_queue' # background jobs
gem 'thruster', require: false # X-Sendfile acceleration to Puma
gem 'turbo-rails'
gem 'tzinfo-data', platforms: [:windows, :jruby] # # Windows does not include zoneinfo files, bundle the tzinfo-data gem
gem 'validates_email_format_of'
gem 'warden' # use for auth
gem 'vite_rails'

group :development, :test do
  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', require: false
  gem 'capybara'
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rouge'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec_rails'
  gem 'rubocop-rails', require: false
end

group :development do
  gem 'annotaterb'
  gem 'bullet'
  gem 'callback_hell'
  gem 'guard', require: false
  gem 'guard-rspec', require: false
  gem 'letter_opener'
  gem 'letter_opener_web', '~> 3.0'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'listen'
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'spring-commands-rspec'

  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'
  # For performance profiling
  gem 'rack-mini-profiler', require: false
  # For memory profiling
  gem 'memory_profiler'
  # For call-stack profiling flamegraphs
  gem 'stackprof'
end

group :test do
  gem 'capybara-email'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'codeclimate-test-reporter', require: nil
  gem 'simplecov', require: nil
  gem 'webmock'
end
