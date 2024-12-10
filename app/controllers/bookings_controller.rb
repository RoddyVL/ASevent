class BookingsController < ApplicationController
  before_action :set_photobooth_and_package, except: :index

  def index
    # @client = Client.find(params[:client_id])
    @bookings = Booking.all
  end

  def new
    @booking = @package.bookings.new
  end

  def create
    @photobooth = Photobooth.find(params[:photobooth_id])
    @package = Package.find(params[:package_id])
    @booking = Booking.new(booking_params)
    @booking.package = @package

    if @booking.save
      redirect_to photobooth_package_bookings_path(@photobooth, @package), notice: 'Booking successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_photobooth_and_package
    @photobooth = Photobooth.find(params[:photobooth_id])
    @package = @photobooth.packages.find(params[:package_id])
  end

  def booking_params
    params.require(:booking).permit(:address, :date, :time, :status, :paiement_status, :booking_status, :client_id)
  end
end
