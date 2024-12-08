class Photobooth < ApplicationRecord
  has_many :packages

  validates :name, presence: true
  validates :description, presence: true
end
