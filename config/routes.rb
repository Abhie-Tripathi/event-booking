Rails.application.routes.draw do
  # API routes
  namespace :api do
    namespace :v1 do
      # Devise routes for JWT authentication
      devise_for :event_organizers,
                controllers: {
                  sessions: 'api/v1/event_organizers/sessions',
                  registrations: 'api/v1/event_organizers/registrations'
                },
                path: 'event_organizers',
                defaults: { format: :json }
      
      devise_for :customers,
                controllers: {
                  sessions: 'api/v1/customers/sessions',
                  registrations: 'api/v1/customers/registrations'
                },
                path: 'customers',
                defaults: { format: :json }

      resources :events do
        resources :tickets
      end
      
      resources :bookings do
        member do
          put :cancel
        end
      end
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
