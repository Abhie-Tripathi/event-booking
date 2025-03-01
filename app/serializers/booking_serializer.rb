class BookingSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :total_amount, :status, :created_at

  belongs_to :customer
  belongs_to :ticket

  # Include event details through ticket
  def event
    object.ticket.event
  end

  # Add event details to the serialized output
  attribute :event do
    {
      id: object.ticket.event.id,
      title: object.ticket.event.title,
      venue: object.ticket.event.venue,
      start_date: object.ticket.event.start_date
    }
  end

  # Add ticket details to the serialized output
  attribute :ticket do
    {
      id: object.ticket.id,
      category: object.ticket.category,
      price: object.ticket.price
    }
  end
end 