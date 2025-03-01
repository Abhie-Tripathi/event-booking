class Booking < ApplicationRecord
  # Relationships
  belongs_to :customer
  belongs_to :ticket

  # Validations
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: %w[pending confirmed cancelled] }
  validate :ticket_availability

  # Callbacks
  before_validation :calculate_total_amount
  after_create :update_ticket_quantity
  after_create :enqueue_confirmation_job

  # Scopes
  scope :confirmed, -> { where(status: 'confirmed') }
  scope :pending, -> { where(status: 'pending') }
  scope :cancelled, -> { where(status: 'cancelled') }

  private

  def ticket_availability
    return unless ticket && quantity

    unless ticket.quantity >= quantity
      errors.add(:quantity, "exceeds available tickets")
    end
  end

  def calculate_total_amount
    return unless ticket && quantity

    self.total_amount = ticket.price * quantity
  end

  def update_ticket_quantity
    ticket.update_quantity(quantity)
  end

  def enqueue_confirmation_job
    BookingConfirmationJob.perform_later(id)
  end
end
