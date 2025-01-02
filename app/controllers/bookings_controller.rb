class BookingsController < ApplicationController
  before_action :allow_guest_for_booking, only: [:new, :create]
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
              name: "Réservation Photobooth - #{@package.photobooth.name}"
            },
            unit_amount: (@package.price * 100).to_i # Convertir le prix en centimes
          },
          quantity: 1
        }],
        mode: 'payment',
        success_url: bookings_url(@booking), # Redirection vers une page de succès après le paiement
        cancel_url: bookings_url(@booking) # Redirection vers une page d'annulation ou retour à la réservation
      })

      @checkout_session_url = session.url # URL pour rediriger vers la session de paiement Stripe
    end
  end

  def new
    @package = Package.find(params[:package_id])
    @booking = Booking.new(package: @package, user: current_user)

      # Si l'utilisateur a choisi de créer un compte
    if params[:booking] && params[:booking][:account_type] == "create"
      @user = User.new # Crée un nouvel utilisateur
    elsif current_user
      # Si l'utilisateur est déjà connecté, on associe l'utilisateur à la réservation
      @user = current_user
    # Si l'utilisateur n'est pas connecté et ne choisit pas de créer un compte
      @user = User.new

      respond_to do |format|
        format.html # standard behavior
        format.turbo_stream { render partial: "bookings/form", locals: { booking: @booking, package: @package } }
      end
    end
  end

  def create
    raise 
    @booking = @package.bookings.new(booking_params)

    if user_signed_in?
      @booking.user = current_user
    else
      case params[:booking][:account_type]
      when "create"
        user_params = params.require(:booking).require(:user).permit(:email, :password)
        user = User.new(user_params)
        if user.save
          sign_in(user)
          @booking.user = user
        else
          render_errors(user) and return
        end
      when "login"
        user = User.find_by(email: params.dig(:booking, :user, :email))
        if user&.authenticate(params.dig(:booking, :user, :password))
          sign_in(user)
          @booking.user = user
        else
          flash.now[:alert] = "Email ou mot de passe invalide."
          render :new, status: :unprocessable_entity and return
        end
      else
        render :new, status: :unprocessable_entity and return
      end
    end

    if @booking.save
      redirect_to photobooth_package_booking_path(@photobooth, @package, @booking), notice: "Réservation créée avec succès."
    else
      render_errors(@booking)
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

  def allow_guest_for_booking
    return if current_user

    # Ignore `authenticate_user!` pour new et create
    true
  end

  def render_errors(record)
    flash.now[:alert] = record.errors.full_messages.to_sentence
    render :new, status: :unprocessable_entity
  end
end
