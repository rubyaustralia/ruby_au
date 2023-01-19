source 'https://rubygems.org'

ruby '2.7.7'

gem 'rails', '~> 6.1.7'
gem 'pg'
gem 'puma'

gem 'bcrypt'
gem 'bugsnag'
gem 'createsend'
gem 'decent_exposure'
gem 'devise'
gem 'icalendar'
gem 'inline_svg', '~> 1.7.2'
gem 'jbuilder'
gem 'kaminari'
gem 'premailer-rails'
gem 'pygmentize'
gem 'redcarpet'
gem 'sassc'
gem 'validates_email_format_of'
gem 'warden' # use for auth
gem 'webpacker', '6.0.0.beta.7'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a
  # debugger console
  gem 'byebug'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 4.0'
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
