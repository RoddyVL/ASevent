class PhotoboothsController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  def index
    @photobooths = Photobooth.where.not(name: "Photobooth temporaire")
    @questions = Question.all
    @question = Question.new
  end


  def show
    @photobooth = Photobooth.find(params[:id])
    @packages = @photobooth.packages
  end

  def new
    @package = Package.find(params[:package_id])
    @booking = Booking.new(package: @package, user: current_user)

    respond_to do |format|
      format.html # standard behavior
      format.turbo_stream { render partial: "bookings/form", locals: { booking: @booking, package: @package } }
    end
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.user = current_user

    if @booking.save
      redirect_to booking_path(@booking), notice: "Réservation créée avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :package_id)
  end
end
