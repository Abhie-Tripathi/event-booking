module Api
  module V1
    class EventsController < BaseController
      skip_before_action :authenticate_user!, only: [:index, :show]
      before_action :set_event, only: [:show, :update, :destroy]

      def index
        @events = Event.includes(:event_organizer, :tickets)
        @events = @events.upcoming if params[:upcoming].present?
        @events = @events.ongoing if params[:ongoing].present?
        @events = @events.past if params[:past].present?

        render json: @events, include: ['event_organizer', 'tickets']
      end

      def show
        render json: @event, include: ['event_organizer', 'tickets']
      end

      def create
        @event = current_user.events.build(event_params)
        authorize @event

        if @event.save
          render json: @event, status: :created
        else
          render json: { errors: @event.errors }, status: :unprocessable_entity
        end
      end

      def update
        authorize @event

        if @event.update(event_params)
          # Send notification to booked customers about event update
          NotifyBookedCustomersJob.perform_later(@event.id)
          render json: @event
        else
          render json: { errors: @event.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @event
        @event.destroy
        head :no_content
      end

      private

      def set_event
        @event = Event.find(params[:id])
      end

      def event_params
        params.require(:event).permit(:title, :description, :venue, :start_date, :end_date)
      end
    end
  end
end 