class Client < ApplicationRecord
  has_many :bookings
  has_many :packages, through: :bookings

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :phone_number, presence: true, format: { with: /\A\+?[0-9\s\-()]+\z/, message: "must be a valid phone number" }
end
