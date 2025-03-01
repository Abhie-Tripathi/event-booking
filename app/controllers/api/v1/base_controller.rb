module Api
  module V1
    class BaseController < ApplicationController
      include Pundit::Authorization

      before_action :authenticate_user!
      
      rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      private

      def authenticate_user!
        if request.headers['Authorization'].present?
          authenticate_event_organizer_or_customer!
        else
          render json: { error: 'Not authenticated' }, status: :unauthorized
        end
      end

      def authenticate_event_organizer_or_customer!
        token = request.headers['Authorization'].split(' ').last
        begin
          jwt_payload = JWT.decode(token, Rails.application.credentials.secret_key_base).first
          
          if jwt_payload['sub'].start_with?('EventOrganizer')
            @current_user = EventOrganizer.find(jwt_payload['sub'].split('_').last)
          else
            @current_user = Customer.find(jwt_payload['sub'].split('_').last)
          end
        rescue JWT::DecodeError => e
          render json: { error: e.message }, status: :unauthorized
        end
      end

      def current_user
        @current_user
      end

      def user_not_authorized
        render json: { error: 'You are not authorized to perform this action.' }, status: :forbidden
      end

      def not_found
        render json: { error: 'Record not found' }, status: :not_found
      end
    end
  end
end 