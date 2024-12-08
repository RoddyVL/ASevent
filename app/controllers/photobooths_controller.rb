class PhotoboothsController < ApplicationController
  def index
    @photobooths = Photobooth.all
  end

  def show
    @photobooth = Photobooth.find(params[:id])
    @packages = @photobooth.packages
  end
end
