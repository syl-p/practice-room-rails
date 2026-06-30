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

  resources :users, only: %i[show]
  resource :registration, controller: "registration", only: %i[new create]

  namespace :settings do
    resource :profile, only: %i[edit update]
    resource :password, only: %i[edit update]
  end

  resources :practices, except: [ :index ] do
    collection do
      get "/new", to: "practices#new", as: :new
    end

    scope module: :practices do
      resources :activities, only: %i[index show]
      resources :practice_entries, only: [ :index, :create, :destroy ]
      resources :progression, only: [ :index ]
      resources :practice_activities, only: [ :create, :destroy ]
    end
  end

  resources :practice_activities, only: [] do
    scope module: :practice_activities do
      resources :goals, only: [ :new, :create ]
    end
  end

  resources :goals, only: :show do
    scope module: :goals do
      resources :goal_progresses, only: [ :index, :create ]
    end
  end

  resources :comments, only: %i[show edit update destroy] do
    resources :comments, only: %i[create], module: :comments
  end

  resources :notifications, only: %i[index]

  resources :activities do
    resources :comments, module: :activities
  end

  post "bookmarks/:activity_id",  to: "bookmarks#create", as: "new_bookmark"
  delete "bookmarks/:activity_id",  to: "bookmarks#destroy", as: "remove_bookmark"

  resources :media
  get "tags", to: "tags#search", as: "tags"

  get "search" => "search#index", as: :search, defaults: { format: :turbo_stream }
  get "search/new" => "search#new", as: :new_search
end
