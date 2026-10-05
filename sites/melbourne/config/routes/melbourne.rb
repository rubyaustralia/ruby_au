# frozen_string_literal: true

Rails.application.routes.draw do
  constraints subdomain: "melbourne" do
    scope module: "melbourne", as: "melbourne" do
      get "/", to: "home#show", as: :home

      resources :events, only: %i[index show], param: :slug

      resources :upcoming_events, only: %i[index]

      resources :past_events, only: %i[index]

      resources :database_events, param: :slug

      get "/talks", to: redirect(
        "https://github.com/rubyaustralia/melbourne-ruby/issues", status: 302
      )

      get "/database_events_home", to: "database_events_home#show", as: :database_events_home
    end
  end
end
