class Ticket < ApplicationRecord
  # Relationships
  belongs_to :event
  has_many :bookings, dependent: :destroy
  has_many :customers, through: :bookings

  # Validations
  validates :category, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Scopes
  scope :available, -> { where('quantity > ?', 0) }

  # Methods
  def available?
    quantity > 0
  end

  def update_quantity(booked_quantity)
    update(quantity: quantity - booked_quantity)
  end
end
