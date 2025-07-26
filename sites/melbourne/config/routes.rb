# frozen_string_literal: true

Melbourne::Engine.routes.draw do
  root to: "home#show"
  resources :events, only: %i[index show], param: :slug
end
