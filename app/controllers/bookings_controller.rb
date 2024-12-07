class BookingsController < ApplicationController
  def index
    @photobooth = Photobooth.find(params[:photobooth_id])
    @package = Package.find(params[:package_id])
    @booking = @package.bookings
  end

  def new
  end
end
