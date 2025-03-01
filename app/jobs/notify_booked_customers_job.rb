class NotifyBookedCustomersJob < ApplicationJob
  queue_as :default

  def perform(event_id)
    event = Event.find(event_id)
    bookings = event.bookings.confirmed

    bookings.each do |booking|
      # In a real application, we would send an actual email here
      puts "Sending event update notification to #{booking.customer.email} for Event: #{event.title}"
    end
  end
end 