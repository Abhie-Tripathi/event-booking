module Api
  module V1
    module Events
      class BookingsController < Api::V1::BaseController
        skip_before_action :authenticate_user!
        before_action :authenticate_event_organizer!
        before_action :set_event
        before_action :authorize_event_organizer

        def index
          Rails.logger.info "Current user: #{current_user.inspect}"
          Rails.logger.info "Event: #{@event.inspect}"
          @bookings = @event.tickets.joins(:bookings).includes(:bookings).flat_map(&:bookings)
          render json: @bookings
        end

        private

        def set_event
          @event = Event.find(params[:event_id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Event not found' }, status: :not_found
        end

        def authorize_event_organizer
          unless @event.event_organizer_id == current_user.id
            render json: { error: 'You are not authorized to view bookings for this event' }, 
                   status: :forbidden
          end
        end
      end
    end
  end
end 