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

      def authenticate_event_organizer!
        auth_header = request.headers['Authorization']
        if auth_header.present? && auth_header.start_with?('Bearer ')
          token = auth_header.split(' ').last
          begin
            jwt_payload = JWT.decode(token, Rails.application.credentials.secret_key_base).first
            Rails.logger.info "JWT Payload: #{jwt_payload.inspect}"
            
            if jwt_payload['scp'] == 'api_v1_event_organizer'
              @current_user = EventOrganizer.find(jwt_payload['sub'])
              Rails.logger.info "Found event organizer: #{@current_user.inspect}"
            else
              Rails.logger.info "Invalid scope: #{jwt_payload['scp']}"
              render json: { error: 'Must be an event organizer' }, status: :forbidden
            end
          rescue JWT::DecodeError => e
            Rails.logger.error "JWT decode error: #{e.message}"
            render json: { error: e.message }, status: :unauthorized
          rescue ActiveRecord::RecordNotFound => e
            Rails.logger.error "Event organizer not found: #{e.message}"
            render json: { error: 'Event organizer not found' }, status: :unauthorized
          end
        else
          Rails.logger.info "Missing or invalid Authorization header: #{auth_header}"
          render json: { error: 'Not authenticated' }, status: :unauthorized
        end
      end

      def authenticate_event_organizer_or_customer!
        auth_header = request.headers['Authorization']
        if auth_header.present? && auth_header.start_with?('Bearer ')
          token = auth_header.split(' ').last
          begin
            jwt_payload = JWT.decode(token, Rails.application.credentials.secret_key_base).first
            
            if jwt_payload['scp'] == 'api_v1_event_organizer'
              @current_user = EventOrganizer.find(jwt_payload['sub'])
            else
              @current_user = Customer.find(jwt_payload['sub'])
            end
          rescue JWT::DecodeError => e
            render json: { error: e.message }, status: :unauthorized
          rescue ActiveRecord::RecordNotFound => e
            render json: { error: 'User not found' }, status: :unauthorized
          end
        else
          render json: { error: 'Not authenticated' }, status: :unauthorized
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