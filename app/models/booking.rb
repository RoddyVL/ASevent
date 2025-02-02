class Booking < ApplicationRecord
  belongs_to :package
  belongs_to :user
  has_one :order
  has_one :chat
  # after_create :create_associated_chat

  enum paiement_status: { pending: 0, paid: 1 }
  enum booking_status: { en_attente: 0, livré: 1, récupéré: 2 }

  validates :address, :date, :time, :package, presence: true
  validates :date, presence: true
  validates :time, presence: true
  validates :package, :user, presence: true

  # private

  #  def create_associated_chat
  #   @chat = Chat.create!(booking: @booking, user: current_user)
  #  end
end
