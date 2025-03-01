Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # API routes
  namespace :api do
    namespace :v1 do
      # Devise routes for JWT authentication
      devise_for :event_organizers,
                controllers: {
                  sessions: 'api/v1/event_organizers/sessions',
                  registrations: 'api/v1/event_organizers/registrations'
                },
                path: 'event_organizers'
      
      devise_for :customers,
                controllers: {
                  sessions: 'api/v1/customers/sessions',
                  registrations: 'api/v1/customers/registrations'
                },
                path: 'customers'

      resources :events do
        resources :tickets
        resources :bookings, only: [:index], controller: 'events/bookings'
      end
      
      resources :bookings, only: [:create, :index, :show] do
        member do
          post :cancel
        end
      end

      namespace :event_organizers do
        post 'sign_in', to: 'sessions#create'
      end

      namespace :customers do
        post 'sign_in', to: 'sessions#create'
      end

      resources :event_organizers, only: [:create]
      resources :customers, only: [:create]
    end
  end

  # Mount Sidekiq web interface
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
