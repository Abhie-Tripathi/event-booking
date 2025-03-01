class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  # Relationships
  has_many :bookings, dependent: :destroy
  has_many :tickets, through: :bookings

  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
