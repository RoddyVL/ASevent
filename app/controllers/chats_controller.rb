class ChatsController < ApplicationController
  def show
    @chat = Chat.find_by(id: params[:id])
    @booking = @chat.booking
    @bookings = current_user.bookings
    @photobooth = @booking.package.photobooth
    @package = @booking.package
    @message = Message.new
    @chat = @booking.chat


    @messages = @chat.messages
  end
end
