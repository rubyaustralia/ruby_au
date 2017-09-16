Rails.application.routes.draw do

  resource :email_confirmation, only: [:show, :create]
  resource :membership, only: [:create, :destroy]
  resources :passwords, only: [:create, :new]
  resource :profile, only: [:edit, :update, :show] do
    resource :password, only: [:edit, :update]
  end
  resource :session, only: :create
  resources :users, only: [:create, :show]

  get "/sign_up" => "users#new", as: "sign_up"
  get "/sign_in" => "sessions#new", as: "sign_in"
  delete "/sign_out" => "sessions#destroy", as: "sign_out"

  root to: 'pages#show', defaults: { id: 'welcome' }

  namespace :admins do
    resources :imports
  end

  get "/*id" => 'pages#show', as: :page, format: false,
    constraints: RootRouteConstraints
end
