web: bundle exec puma -C config/puma.rb
release: ./bin/vite build && bundle exec rails db:migrate && bundle exec rails tmp:cache:clear && bundle exec rails assets:precompile
