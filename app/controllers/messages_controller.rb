class MessagesController < ApplicationController
  def index
    if current_user.admin
      @bookings_messages = Booking.all
    else
      @bookings_messages = current_user.bookings
    end
  end

  def create
    @booking = Booking.find(params[:booking_id])
    @message = @booking.chat.messages.new(message_params)
    @message.booking = @booking
    @message.user = current_user
    @messages = Message.all

  # Recharger les données nécessaires pour la vue en cas d'erreur
  @booking = @message.booking
  @package = @booking.package

    if @message.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(:messages, partial: "messages/message",
            target: "messages",
            locals: { message: @message, user: current_user })
        end
        format.html { redirect_to booking_path(@booking) }
      end
    else
      render "bookings/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
