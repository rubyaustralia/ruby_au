Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  namespace :my do
    resource :details, only: [:show, :edit, :update]
    resource :password, only: [:update]
    resource :membership, only: [:destroy]
    resources :meetings, only: [:index]
    resources :access_requests, only: [:index]
    resource :slack_invite, only: [:show]
    resources :emails, only: [:new, :create, :destroy] do
      member do
        put :set_primary
      end
    end
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
    resources :posts, only: [:index, :new, :create]
    get 'posts/*slug/edit', to: 'posts#edit', as: :edit_post
    get 'posts/*slug', to: 'posts#show', as: :post
    patch 'posts/*slug', to: 'posts#update', as: :update_post
  end

  resources :invitations, only: [] do
    member do
      get :unsubscribe, :new
      post :create
    end
  end

  resources :posts, only: [:index]
  get 'posts/*slug', to: 'posts#show', as: :post

  resources :mailing_lists, only: [] do
    member { post :hook }
  end

  post '/slack/hook' => 'slack#hook'

  # Off-site Redirection routes
  get '/forum', to: redirect('https://forum.ruby.org.au'), as: :forum
  get '/mailing-list', to: redirect('https://confirmsubscription.com/h/j/3DDD74A0ACC3DB22'), as: :roro_mailing_list
  get '/slack', to: redirect("/my/slack_invite")
  get '/videos', to: redirect('https://www.youtube.com/@RubyAustralia'), as: :videos
  get '/merch', to: redirect('https://www.redbubble.com/people/ruby-au/explore'), as: :merch

  get "/events/rubyconf_au_2021" => "events#rubyconf_au_2021"
  get "/events/rails_camp_27" => "events#rails_camp_27"

  root to: 'pages#show', defaults: { id: 'welcome' }

  get "/policies" => "policies#index", as: :policies
  get "/policies/*id" => "policies#show", as: :policy

  get "/sponsorship" => 'sponsors#index'
  get "/sponsors/*id" => 'sponsors#show'

  get "/code-of-conduct", to: redirect("/policies/code-of-conduct")
  get "/code-of-conduct-enforcement", to: redirect("/policies/code-of-conduct-enforcement")
  get "/code-of-conduct-reporting", to: redirect("/policies/code-of-conduct-reporting")

  get "/*id" => 'pages#show', as: :page, format: false, constraints: RootRouteConstraints
end
