Rails.application.routes.draw do
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, only: :create

  resources :users, only: [:create, :edit, :update, :show] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "users#new", as: "sign_up"
  get "/just_joined" => "users#just_joined", as: "just_joined"
  # For details on the DSL available within this file,
  # see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
  root to: 'welcome#index'
  resources :welcome, only: [:index]

  # URL backwards compatibility
  # remove after July 2017 or so
  get '/articles/2017-03-24-ruby-au-elections' =>
    redirect('https://forum.ruby.org.au/t/may-2017-ruby-australia-committee-elections/186/5')
  get '/articles/2016-11-21-ruby-au-elections' =>
    redirect('https://forum.ruby.org.au/t/dec-2016-ruby-australia-committee-elections/185')
  get '/articles/2014-02-26-gender-equality' =>
    redirect('https://forum.ruby.org.au/t/on-gender-equality-in-the-australian-ruby-community/184')

  get "/*id" => 'pages#show', as: :page, format: false,
    constraints: RootRouteConstraints
end
