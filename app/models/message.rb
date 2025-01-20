class Message < ApplicationRecord
  belongs_to :user
  belongs_to :booking
  belongs_to :chat

  after_create_commit :broadcast_message


  validates :content, presence: true

  private

  def broadcast_message
    broadcast_append_to "booking_#{booking.id}_messages",
                        partial: "messages/message",
                        target: "messages",
                        locals: { message: self, user: user }
  end
end
