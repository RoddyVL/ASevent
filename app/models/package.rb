class Package < ApplicationRecord
    belongs_to :photobooth
    has_many :bookings, dependent: :destroy

    validates :hour, presence: true
    validates :price, presence: true
    monetize :price_cents
end
