class PackagesController < ApplicationController
  def index
    @packages = Package.all
  end

  def show
    @package = Package.find(params[:id])
    @photobooth = @package.photobooth
    @booking = Booking.new
  end

end
