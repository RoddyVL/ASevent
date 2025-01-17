class Photobooth < ApplicationRecord
  has_many :packages
  has_many :photos, dependent: :destroy


  validates :name, presence: true
  validates :description, presence: true
end
