# frozen_string_literal: true

Rails.application.routes.draw do
  constraints subdomain: "melbourne" do
    scope module: "melbourne", as: "melbourne" do
      get "/", to: "home#show", as: :home

      resources :events, only: %i[index show], param: :slug

      get "/events/upcoming", to: "upcoming_events#index"
      resources :upcoming_events, only: %i[index]

      # get "/events/past", to: "past_events#index", as: :past_events
      # resources :past_events, only: %i[index], param: :slug

      get "/talks", to: redirect(
        "https://github.com/rubyaustralia/melbourne-ruby/issues", status: 302
      )
    end
  end
end
