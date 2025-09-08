Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  mount MissionControl::Jobs::Engine, at: "/jobs"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#home"
  get "dashboard" => "dashboard#index", as: :dashboard

  resources :users, only: %i[show]
  post "follows/:id", to: "follows#create", as: "follow"
  delete "follows/:id", to: "follows#destroy", as: "unfollow"

  resource :registration, controller: "registration", only: %i[new create]

  namespace :settings do
    resource :profile, only: %i[edit update]
    resource :password, only: %i[edit update]
  end

  resources :practices, except: [:show] do
    # for fixing url /new vs /:practice_id
    collection do
      get  "/new", to: "practices#new", as: :new
    end

    scope module: :practices do
      get "", to: "activities#index", as: :root
      post "filter", to: "activities#filter", as: "filter_activities", defaults: { format: :turbo_stream }
    end
  end

  resources :comments, only: %i[show edit update destroy] do
    resources :comments, only: %i[create], module: :comments
  end

  resources :notifications, only: %i[index]

  resources :activities do
    resources :comments, module: :activities
  end

  post "favorites/:activity_id",  to: "favorites#create", as: "new_favorite"
  delete "favorites/:activity_id",  to: "favorites#destroy", as: "remove_favorite"

  resources :media
  get "tags", to: "tags#search", as: "tags"

  get "search" => "search#index", as: :search, defaults: { format: :turbo_stream }
  get "search/new" => "search#new", as: :new_search

  resources :practiced_activities, only: [ :create, :destroy ]
end
