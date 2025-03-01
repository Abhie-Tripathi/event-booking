module Api
  module V1
    class BookingsController < BaseController
      before_action :set_booking, only: [:show, :cancel]

      def index
        @bookings = current_user.bookings.includes(:ticket, ticket: :event)
        render json: @bookings, include: ['ticket', 'ticket.event']
      end

      def show
        authorize @booking
        render json: @booking, include: ['ticket', 'ticket.event']
      end

      def create
        @booking = current_user.bookings.build(booking_params)
        @booking.status = 'pending'

        # Check if user is a Customer
        unless current_user.is_a?(Customer)
          render json: { error: 'Only customers can create bookings' }, status: :forbidden
          return
        end

        # Check if ticket exists and has available quantity
        ticket = Ticket.find(booking_params[:ticket_id])
        if ticket.nil? || ticket.quantity < booking_params[:quantity].to_i
          render json: { error: 'Ticket not available or insufficient quantity' }, status: :unprocessable_entity
          return
        end

        if @booking.save
          # Decrease ticket quantity
          ticket.update(quantity: ticket.quantity - @booking.quantity)
          BookingConfirmationJob.perform_later(@booking.id)
          render json: @booking, status: :created
        else
          render json: { errors: @booking.errors }, status: :unprocessable_entity
        end
      end

      def cancel
        authorize @booking
        
        if @booking.update(status: 'cancelled')
          # Return tickets to inventory
          @booking.ticket.update(quantity: @booking.ticket.quantity + @booking.quantity)
          render json: @booking
        else
          render json: { errors: @booking.errors }, status: :unprocessable_entity
        end
      end

      private

      def set_booking
        @booking = Booking.find(params[:id])
      end

      def booking_params
        params.require(:booking).permit(:ticket_id, :quantity)
      end
    end
  end
end 