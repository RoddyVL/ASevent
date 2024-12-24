class PaymentsController < ApplicationController
  def new
    @order = current_user.orders.where(state: 'pending').find(params[:order_id])
  end

  class PaymentsController < ApplicationController
    def create
      package = Package.find(params[:package_id])

      # Crée une session Stripe Checkout
      session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [{
          name: package.name,
          amount: package.price_cents,
          currency: 'eur',
          quantity: 1,
        }],
        mode: 'payment',
        success_url: booking_success_url + '?session_id={CHECKOUT_SESSION_ID}',
        cancel_url: booking_cancel_url
      )

      # Redirige l'utilisateur vers la page Stripe
      redirect_to session.url, allow_other_host: true
    rescue Stripe::StripeError => e
      flash[:error] = e.message
      redirect_to new_booking_path
    end

    def success
      # Logique après paiement réussi
    end

    def cancel
      # Logique après annulation
    end
  end

end
