Rails.application.routes.draw do
  devise_for :users
  
  # Profile routes
  resource :profile, only: [:show]
  
  # Pet routes with nested adoption requests
  resources :pets do
    resources :adoption_requests, only: [:new, :create]
  end
  
  # Standalone adoption request routes
  resources :adoption_requests, only: [:index, :show, :update, :destroy]
  
  get 'profile', to: 'users#profile'
  
  # Set the homepage as root
  root 'home#index'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
