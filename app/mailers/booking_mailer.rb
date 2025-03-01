class BookingMailer < ApplicationMailer
  def confirmation_email(booking)
    @booking = booking
    @customer = booking.customer
    @ticket = booking.ticket
    @event = booking.ticket.event

    mail(
      to: @customer.email,
      subject: "Booking Confirmation - #{@event.title}"
    )
  end
end 