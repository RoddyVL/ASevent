class Chat < ApplicationRecord
  belongs_to :booking
  belongs_to :user
  has_many :messages
end
