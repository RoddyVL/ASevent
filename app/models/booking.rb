class Booking < ApplicationRecord
  belongs_to :package
  belongs_to :user
  has_one :order
  has_many :messages

  enum status: { pending: 0, paid: 1, failed: 2 }

  validates :address, :date, :time, :package, presence: true
  validates :date, presence: true
  validates :time, presence: true
  validates :package, :user, presence: true

  # validates :address, :date, :time, presence: true
end
