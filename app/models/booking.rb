class Booking < ApplicationRecord
  belongs_to :package
  belongs_to :user
  has_one :order
  has_one :chat
  # after_create :create_associated_chat

  enum status: { pending: 0, paid: 1, failed: 2 }

  validates :address, :date, :time, :package, presence: true
  validates :date, presence: true
  validates :time, presence: true
  validates :package, :user, presence: true

  # private

  #  def create_associated_chat
  #   @chat = Chat.create!(booking: @booking, user: current_user)
  #  end
end
