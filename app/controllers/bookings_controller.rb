class BookingsController < ApplicationController
  before_action :allow_guest_for_booking, only: [:new, :create]
  before_action :set_photobooth_and_package, except: :index
  # before_action :check_admin, only: [:index]

  def index
    if current_user.admin
      @bookings = Booking.all
    else
      @bookings = current_user.bookings
    end
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
    # Si l'utilisateur est déjà connecté, on associe l'utilisateur à la réservation
    elsif current_user
      @user = current_user
    else
      # Si l'utilisateur n'est pas connecté et ne choisit pas de créer un compte
      @user = User.new
    end

    respond_to do |format|
      format.html # standard behavior
      format.turbo_stream { render partial: "bookings/form", locals: { booking: @booking, package: @package } }
    end
  end

  def create
    booking_params = params[:booking]

    @booking = @package.bookings.new(
      address: booking_params[:address],
      date: booking_params[:date],
      time: DateTime.new(
        booking_params["time(1i)"].to_i,
        booking_params["time(2i)"].to_i,
        booking_params["time(3i)"].to_i,
        booking_params["time(4i)"].to_i,
        booking_params["time(5i)"].to_i
      )
    )

    # cas ou il veut créer un compte
    if params[:account_type] == "create"
      user = User.find_by(email: user_params[:email])

      if user
        flash.now[:alert] = "Cet email est déjà utilisé. Veuillez vous connecter."
        render :new, status: :unprocessable_entity and return
      else
        user = User.new(user_params)
        if user.save
          sign_in(user)
          @booking.user = user
        else
          flash.now[:alert] = "Impossible de créer le compte : #{user.errors.full_messages.to_sentence}"
          render :new, status: :unprocessable_entity and return
        end
      end

    # cas où il se veut connecter
    elsif params[:account_type] == "login"
      user = User.find_by(email: user_params[:email])

      if user&.valid_password?(user_params[:password])
        sign_in(user)
        @booking.user = user
      else
        flash.now[:alert] = "Email ou mot de passe incorrect."
        render :new, status: :unprocessable_entity and return
      end

    # cas où  il est déjà connecté
    elsif user_signed_in?
      @booking.user = current_user
    end

    if @booking.save
      AdminNotifierMailer.new_booking_notification(@booking).deliver_now
      redirect_to photobooth_package_booking_path(@photobooth, @package, @booking), notice: "Réservation créée avec succès."
    else
      flash.now[:alert] = "Impossible de créer la réservation : #{@booking.errors.full_messages.to_sentence}"
      render :new, status: :unprocessable_entity
    end
  end

private

  def render_errors(record)
    flash.now[:alert] = record.errors.full_messages.to_sentence
    render :new, status: :unprocessable_entity
  end

  def allow_guest_for_booking
    # Cette méthode est appelée avant certaines actions pour permettre l'accès
    # Ignore `authenticate_user!` pour new et create
    true
  end

  def set_photobooth_and_package
    @photobooth = Photobooth.find(params[:photobooth_id])
    @package = @photobooth.packages.find(params[:package_id])
  end

  def user_params
    params.require(:booking).require(:user).permit(:email, :password)
  end

  def check_admin
    unless current_user&.admin?
      flash[:alert] = "Vous n'avez pas l'autorisation d'accéder à cette page."
      redirect_to root_path # ou vers une autre page si nécessaire
    end
  end
end
