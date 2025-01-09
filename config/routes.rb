Rails.application.routes.draw do
  devise_for :users
  root to: "photobooths#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :photobooths, only: %i[show] do
    resources :packages, only: %i[index show] do
      resources :bookings, only: %i[new create]
    end
  end

  resources :bookings, only: %i[index show] do
    resources :messages, only: :create
  end

  resources :orders, only: [:show, :create] do
    resources :payments, only: :new
  end
end
