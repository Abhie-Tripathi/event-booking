class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :venue, :start_date, :end_date, :created_at, :updated_at

  belongs_to :event_organizer
  has_many :tickets

  def event_organizer
    {
      id: object.event_organizer.id,
      name: object.event_organizer.name,
      email: object.event_organizer.email
    }
  end
end 