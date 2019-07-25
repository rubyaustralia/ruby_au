source 'https://rubygems.org'

ruby '2.6.3'

gem 'rails', '~> 5.2'
gem 'pg'
gem 'puma'

gem 'bcrypt'
gem 'bugsnag'
gem 'decent_exposure'
gem 'devise'
gem 'inline_svg', '~> 1.3.1'
gem 'jbuilder'
gem 'pygmentize'
gem 'redcarpet'
gem 'validates_email_format_of'
gem 'warden' # use for auth
gem 'webpacker', '~> 4.0'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a
  # debugger console
  gem 'byebug'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 3.5'
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
      git: 'https://github.com/cgunther/capybara-email.git',
      branch: 'capybara-3.17-click_on-disabled'
  gem 'rails-controller-testing'
  gem "codeclimate-test-reporter", require: nil
  gem "simplecov", require: nil
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
