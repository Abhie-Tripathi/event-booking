class Booking < ApplicationRecord
  # Relationships
  belongs_to :customer
  belongs_to :ticket

  # Validations
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: %w[pending confirmed cancelled] }
  validate :ticket_availability

  # Callbacks
  before_validation :calculate_total_amount
  after_create :update_ticket_quantity
  after_create :send_confirmation_email

  # Scopes
  scope :confirmed, -> { where(status: 'confirmed') }
  scope :pending, -> { where(status: 'pending') }
  scope :cancelled, -> { where(status: 'cancelled') }

  private

  def calculate_total_amount
    self.total_amount = quantity * ticket.price if ticket && quantity
  end

  def ticket_availability
    return unless ticket && quantity

    unless ticket.quantity >= quantity
      errors.add(:quantity, "exceeds available tickets")
    end
  end

  def update_ticket_quantity
    ticket.update_quantity(quantity)
  end

  def send_confirmation_email
    BookingMailer.confirmation_email(self).deliver_later
  end
end
