class BookingConfirmationJob < ApplicationJob
  queue_as :default

  def perform(booking_id)
    booking = Booking.find(booking_id)
    
    # In a real application, we would send an actual email here
    puts "Sending booking confirmation email to #{booking.customer.email} for Event: #{booking.ticket.event.title}"
    
    # Update booking status to confirmed
    booking.update(status: 'confirmed')
  end
end 