Rails.application.routes.draw do
  devise_for :users

  namespace :my do
    resource :details, only: [:show, :edit, :update]
    resource :password, only: [:update]
    resource :membership, only: [:destroy]
    resources :meetings, only: [:index]
    resources :access_requests, only: [:index]
  end

  resources :rsvps, only: [:show, :update, :destroy] do
    member { get :confirm, :decline }
  end

  resources :reactivations, only: [:new, :create]

  namespace :admin do
    resources :memberships, only: [:index]
    resources :access_requests, except: [:destroy]
    resources :imported_members, only: [:index, :create]
    resources :campaigns
  end

  resources :invitations, only: [] do
    member do
      get :unsubscribe, :new
      post :create
    end
  end

  resources :mailing_lists, only: [] do
    member { post :hook }
  end

  get '/forum', to: redirect('https://forum.ruby.org.au'),
    as: :forum
  get '/mailing-list', to: redirect('https://confirmsubscription.com/h/j/3DDD74A0ACC3DB22'),
    as: :roro_mailing_list
  get '/slack', to: redirect('https://ruby-au-join.herokuapp.com/'),
    as: :slack
  get '/videos', to: redirect('https://www.youtube.com/channel/UCr38SHAvOKMDyX3-8lhvJHA/videos'),
    as: :videos

  get "/events/rubyconf_au_2021" => "events#rubyconf_au_2021"
  get "/events/rails_camp_27" => "events#rails_camp_27"

  root to: 'pages#show', defaults: { id: 'welcome' }

  get "/policies" => "policies#index", as: :policies
  get "/policies/*id" => "policies#show", as: :policy

  get "/sponsorship" => 'sponsors#index'
  get "/sponsors/*id" => 'sponsors#show'

  get "/*id" => 'pages#show', as: :page, format: false,
    constraints: RootRouteConstraints
end
