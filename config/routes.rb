Rails.application.routes.draw do
  # For details on the DSL available within this file,
  # see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
  root to: 'welcome#index'
  resources :welcome, only: [:index]

  get "/meetups/*id" => "meetups#show"

  get  "/*id" => 'pages#show', as: :page, format: false,
    constraints: RootRouteConstraints
end
