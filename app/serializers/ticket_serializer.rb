class TicketSerializer < ActiveModel::Serializer
  attributes :id, :category, :price, :quantity, :created_at, :updated_at
  
  belongs_to :event
end 