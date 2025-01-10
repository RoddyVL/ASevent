class Message < ApplicationRecord
  belongs_to :user
  belongs_to :booking

  after_create_commit :broadcast_message


  private

  def broadcast_message
    broadcast_append_to "booking_#{booking.id}_messages",
                        partial: "bookings/message",
                        target: "messages",
                        locals: { message: self }
  end
end
