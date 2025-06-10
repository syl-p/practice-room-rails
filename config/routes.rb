Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "activities#index"
  get "dashboard" => "dashboard#index", as: :dashboard

  resources :users, only: %i[show]

  resources :comments, only: %i[show edit update destroy] do
    resources :comments, only: %i[create], module: :comments
  end

  resources :activities do
    resources :comments, module: :activities, only: [ :index, :create ]
  end

  resources :practiced_activities, only: [ :create, :destroy ]
end
