module Api
  module V1
    module Customers
      class SessionsController < Devise::SessionsController
        respond_to :json

        private

        def respond_with(resource, _opts = {})
          token = request.env['warden-jwt_auth.token']
          render json: {
            status: { code: 200, message: 'Logged in successfully.' },
            data: {
              id: resource.id,
              email: resource.email,
              name: resource.name,
              token: token
            }
          }
        end

        def respond_to_on_destroy
          if current_customer
            render json: {
              status: 200,
              message: "Logged out successfully."
            }
          else
            render json: {
              status: 401,
              message: "Couldn't find an active session."
            }
          end
        end
      end
    end
  end
end 