source 'https://rubygems.org'

ruby file: ".ruby-version"

gem 'rails', '>= 8.0.0'
gem 'pg'
gem 'puma'

gem 'bcrypt'
gem 'bugsnag'
gem 'createsend'
gem 'decent_exposure'
gem 'devise'
gem 'devise-multi_email', github: 'rubyaustralia/devise-multi_email', branch: 'main'
gem 'friendly_id', '>= 5.5'
gem 'icalendar'
gem "image_processing", "~> 1.13"
gem 'inline_svg', '~> 1.10.0'
gem 'jbuilder'
gem 'kaminari'
gem 'premailer-rails'
gem 'pygmentize'
gem 'redcarpet'
gem 'turbo-rails'
gem 'validates_email_format_of'
gem 'warden' # use for auth
gem 'vite_rails'
gem 'ahoy_matey' # analytics
gem 'geocoder' # geo location for ahoy
gem 'herb', '~> 0.8.5'
# background jobs
gem 'solid_queue'

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false
  gem 'capybara'
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec_rails'
  gem 'rubocop-rails', require: false
  gem 'pry-rails'
end

group :development do
  gem "annotaterb"
  gem "bullet"
  gem "callback_hell"
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'listen'
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'spring-commands-rspec'
  gem 'guard', require: false
  gem 'guard-rspec', require: false
  gem 'letter_opener'
  gem 'letter_opener_web', '~> 3.0'
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :test do
  gem 'capybara-email'
  gem 'rails-controller-testing'
  gem "selenium-webdriver"
  gem "codeclimate-test-reporter", require: nil
  gem "simplecov", require: nil
  gem 'webmock'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:windows, :jruby]

gem "meta-tags", "~> 2.22"
gem "rouge"
