class Booking < ApplicationRecord
  belongs_to :package
  belongs_to :client

  enum status: { pending: 0, paid: 1, failed: 2 }

  validates :address, presence: true
  validates :date, presence: true
  validates :time, presence: true
  validates :status, presence: true
end
