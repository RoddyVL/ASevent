class BookingsController < ApplicationController
  before_action :set_photobooth_and_package, except: :index

  def index
    @bookings = Booking.all
  end

  def show
    @booking = Booking.find(params[:id])
    @photobooth = @booking.package.photobooth
    @package = @booking.package

    @stripe_publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']

     # Créer une session Stripe si la réservation n'est pas encore payée
     if @booking.paiement_status != "paid"
      session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: [{
          price_data: {
            currency: 'eur',
            product_data: {
              name: "Réservation Photobooth - #{@package.photobooth.name}",
            },
            unit_amount: (@package.price * 100).to_i, # Convertir le prix en centimes
          },
          quantity: 1,
        }],
        mode: 'payment',
        success_url: bookings_url(@booking),  # Redirection vers une page de succès après le paiement
        cancel_url: bookings_url(@booking),    # Redirection vers une page d'annulation ou retour à la réservation
      })

      @checkout_session_url = session.url # URL pour rediriger vers la session de paiement Stripe
    end
  end

  def new
    @booking = @package.bookings.new
    @stripe_publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']
  end

  def create
    @booking = @package.bookings.new(booking_params)
    @booking.user = current_user # Associe le booking à l'utilisateur connecté
    @booking.save

    # Initialiser les statuts par défaut
    @booking.status ||= 0
    @booking.paiement_status ||= 0
    @booking.booking_status ||= 0

    if @booking.save
      redirect_to photobooth_package_booking_path(@photobooth, @package, @booking)

    else
      flash[:alert] = "Erreur lors de la création de la réservation."
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
