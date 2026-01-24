Rails.application.routes.draw do
  constraints subdomain: "melbourne" do
    mount(Melbourne::Engine, at: "/")
  end

  # Devise is causing a deprecation warning:
  #   DEPRECATION WARNING: resource received a hash argument only. Please use a keyword instead.
  #                        Support to hash argument will be removed in Rails 8.2.
  # This intends to be solved in Devise 5.0, but no release date is set yet.
  # See: https://github.com/heartcombo/devise/issues/5735
  devise_for :users, controllers: {
    registrations: 'registrations',
    passwords: 'devise/passwords'
  }

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  mount Ahoy::Engine => "/ahoy", as: :analytics_tracking unless Rails.env.test?

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
    member do
      get :confirm
      get :decline
    end
  end

  resources :reactivations, only: [:new, :create]

  namespace :admin do
    resource :dashboard, only: [:show]
    patch 'update_user_role', to: 'user_management#update_role'
    delete 'delete_user', to: 'user_management#delete'
    delete 'force_delete_user', to: 'user_management#force_delete'
    patch 'deactivate_user', to: 'user_management#deactivate'
    resources :memberships, only: [:index]
    resources :access_requests, except: [:destroy]
    resources :imported_members, only: [:index, :create]
    resources :campaigns
    resources :posts, only: [:index, :new, :create]
    get 'posts/*slug/edit', to: 'posts#edit', as: :edit_post
    delete 'posts/*slug/edit', to: 'posts#destroy', as: :delete_post
    post 'posts/*slug/archive', to: 'posts#archive', as: :archive_post
    get 'posts/*slug', to: 'posts#show', as: :post
    patch 'posts/*slug', to: 'posts#update', as: :update_post
    resources :analytics, only: [:index]
  end

  namespace :api do
    namespace :youtube do
      get 'playlist/:id', to: 'playlists#show'
    end
  end

  resources :invitations, only: [] do
    member do
      get :unsubscribe
      get :new
      post :create
    end
  end

  resources :posts, only: [:index]
  get 'posts/feed.rss', to: 'posts#feed', format: 'rss'
  get 'posts/*slug', to: 'posts#show', as: :post

  resources :mailing_lists, only: [] do
    member do
      post :hook
    end
  end

  post '/slack/hook' => 'slack#hook'

  # Off-site Redirection routes
  get '/forum', to: redirect('https://forum.ruby.org.au'), as: :forum
  get '/mailing-list', to: redirect('https://confirmsubscription.com/h/j/3DDD74A0ACC3DB22'), as: :roro_mailing_list
  get '/contributions', to: redirect('https://github.com/orgs/rubyaustralia/projects/14'), as: :community_contributions
  get '/slack', to: redirect("/my/slack_invite")
  get '/videos', to: redirect('https://www.youtube.com/@RubyAustralia'), as: :videos
  get '/merch', to: redirect('https://www.redbubble.com/people/ruby-au/explore'), as: :merch

  get "/events/rubyconf_au_2021" => "events#rubyconf_au_2021"
  get "/events/rails_camp_27" => "events#rails_camp_27"
  get "/events", to: "events#index"

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
