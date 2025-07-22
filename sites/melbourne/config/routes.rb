# frozen_string_literal: true

Melbourne::Engine.routes.draw do
  root to: "home#show"
  resources :events, only: %i[show], param: :slug
  get "/events", to: redirect("/")
end
