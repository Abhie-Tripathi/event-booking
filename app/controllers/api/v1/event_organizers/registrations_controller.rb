module Api
  module V1
    module EventOrganizers
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json

        private

        def respond_with(resource, _opts = {})
          if resource.persisted?
            token = request.env['warden-jwt_auth.token'] || generate_jwt_token(resource)
            render json: {
              status: { code: 200, message: 'Registered successfully.' },
              data: {
                id: resource.id,
                email: resource.email,
                name: resource.name,
                token: token
              }
            }
          else
            render json: {
              status: { code: 422, message: "Registration failed." },
              errors: resource.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        def sign_up_params
          params.require(:event_organizer).permit(:email, :password, :name)
        end

        protected

        def generate_jwt_token(resource)
          JWT.encode(
            { sub: "EventOrganizer_#{resource.id}", exp: 24.hours.from_now.to_i },
            Rails.application.credentials.secret_key_base
          )
        end
      end
    end
  end
end 