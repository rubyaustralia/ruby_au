source 'https://rubygems.org'

ruby '3.3.5'

gem 'rails', '>= 8.0.0'
gem 'pg'
gem 'puma'

gem 'bcrypt'
gem 'bugsnag'
gem 'createsend'
gem 'decent_exposure'
gem 'devise'
gem 'devise-multi_email'
gem 'friendly_id', '~> 5.5.0'
gem 'icalendar'
gem "image_processing", "~> 1.13"
gem 'inline_svg', '~> 1.9.0'
gem 'jbuilder'
gem 'kaminari'
gem 'premailer-rails'
gem 'pygmentize'
gem 'redcarpet'
gem 'sprockets-rails'
gem 'turbo-rails'
gem 'validates_email_format_of'
gem 'warden' # use for auth
gem 'vite_rails'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a
  # debugger console
  gem 'byebug'
  gem 'faker'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 6.1.0'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'factory_bot_rails'
  gem 'capybara'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'
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
end

group :test do
  gem 'capybara-email',
      git: 'https://github.com/DavyJonesLocker/capybara-email.git',
      branch: 'master',
      ref: 'e1f61aa9b4'
  gem 'rails-controller-testing'
  gem "codeclimate-test-reporter", require: nil
  gem "simplecov", require: nil
  gem 'webmock'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
