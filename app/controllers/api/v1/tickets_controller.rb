module Api
  module V1
    class TicketsController < BaseController
      skip_before_action :authenticate_user!, only: [:index]
      before_action :set_event
      before_action :set_ticket, only: [:show, :update, :destroy]

      def index
        @tickets = @event.tickets.includes(:event)
        @tickets = @tickets.available if params[:available].present?

        render json: @tickets
      end

      def show
        render json: @ticket
      end

      def create
        authorize @event, :manage?
        @ticket = @event.tickets.build(ticket_params)

        if @ticket.save
          render json: @ticket, status: :created
        else
          render json: { errors: @ticket.errors }, status: :unprocessable_entity
        end
      end

      def update
        authorize @event, :manage?

        if @ticket.update(ticket_params)
          render json: @ticket
        else
          render json: { errors: @ticket.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @event, :manage?
        @ticket.destroy
        head :no_content
      end

      private

      def set_event
        @event = Event.find(params[:event_id])
      end

      def set_ticket
        @ticket = @event.tickets.find(params[:id])
      end

      def ticket_params
        params.require(:ticket).permit(:category, :price, :quantity)
      end
    end
  end
end 