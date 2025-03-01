class BookingConfirmationJob < ApplicationJob
  queue_as :default

  def perform(booking_id)
    booking = Booking.find(booking_id)
    
    # Log email details instead of sending
    Rails.logger.info "=== Booking Confirmation Email Details ==="
    Rails.logger.info "To: #{booking.customer.email}"
    Rails.logger.info "Subject: Booking Confirmation - #{booking.ticket.event.title}"
    Rails.logger.info "Booking ID: #{booking.id}"
    Rails.logger.info "Event: #{booking.ticket.event.title}"
    Rails.logger.info "Ticket Type: #{booking.ticket.category}"
    Rails.logger.info "Quantity: #{booking.quantity}"
    Rails.logger.info "Total Amount: $#{booking.total_amount}"
    Rails.logger.info "===================================="
  end
end 