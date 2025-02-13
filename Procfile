web: bundle exec puma -C config/puma.rb
release: bin/heroku-release bundle exec rails db:migrate tmp:cache:clear assets:precompile
