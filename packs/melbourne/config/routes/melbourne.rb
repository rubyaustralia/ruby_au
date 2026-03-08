# frozen_string_literal: true

Rails.application.routes.draw do
  constraints subdomain: "melbourne" do
    scope module: "melbourne", as: "melbourne" do
      get "/", to: "home#show", as: :home

      resources :events, only: %i[index show], param: :slug
    end
  end
end
