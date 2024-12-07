class Photobooth < ApplicationRecord
  has_many :packages
  
  validates :name, presence: true
  validates :description, presence: true
  validates :image_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "not valid URL" }
end
