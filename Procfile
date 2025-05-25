web: bundle exec puma -C config/puma.rb
release: bundle exec rails db:migrate && bundle exec rails tmp:cache:clear && bundle exec rails assets:precompile && ./bin/vite build
