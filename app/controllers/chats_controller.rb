class ChatsController < ApplicationController
  def show
    @chat = Chat.find_by(id: params[:id])
    @booking = @chat.booking
    @photobooth = @booking.package.photobooth
    @package = @booking.package
    @message = Message.new
    @chat = @booking.chat
    @bookings = nil

    if current_user.admin
      @bookings = Booking.all
    else
      @bookings = current_user.bookings
    end

    @messages = @chat.messages
  end
end
