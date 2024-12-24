class BookingsController < ApplicationController
  before_action :set_photobooth_and_package, except: :index

  def index
    # @client = Client.find(params[:client_id])
    @bookings = Booking.all
  end

  def new
    @booking = @package.bookings.new
    @stripe_publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']
  end

  def create
    @photobooth = Photobooth.find(params[:photobooth_id])
    @package = Package.find(params[:package_id])
    @booking = Booking.new(booking_params)
    @booking.package = @package

    if @booking.save
      session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: [{
          price_data: {
            currency: 'eur',
            product_data: {
              name: "Réservation Photobooth",
            },
            unit_amount: @booking.amount_cents, # Montant de la réservation en centimes
          },
          quantity: 1,
        }],
        mode: 'payment',
        success_url: booking_success_url,  # Remplace par ton URL de succès
        cancel_url: booking_cancel_url,    # Remplace par ton URL d'annulation
      })

      # Rediriger vers la session Stripe
      redirect_to session.url, allow_other_host: true
    else
      render :new
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
