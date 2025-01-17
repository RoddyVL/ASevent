class OrdersController < ApplicationController
  def show
    @order = current_user.orders.find(params[:id])
  end

  def index
    @bookings = current_user.bookings.where(paiement_status: 0)
    @packages = []
    @packages = @bookings.map { |booking| booking.package }
    @total_price = (@packages.map { |package| package.price_cents }).sum
    @package = Package.last
    @package.update(price_cents: @total_price)


    @stripe_publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']

      session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: [{
          price_data: {
            currency: 'eur',
            product_data: {
              name: "toutes mes réservations"
            },
            unit_amount: @total_price.to_i
          },
          quantity: 1
        }],
        mode: 'payment',
        success_url: bookings_url(@booking), # Redirection vers une page de succès après le paiement
        cancel_url: bookings_url(@booking) # Redirection vers une page d'annulation ou retour à la réservation
      })

      @checkout_session_url = session.url # URL pour rediriger vers la session de paiement Stripe
  end

  def create
    package = Package.find(params[:package_id])
    order  = Order.create!(package: package, booking_sku: 'package.sku', amount: package.price, state: 'pending', user: current_user)

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        name: package.photobooth.name,
        images: [package.photobooth.image_url],
        amount: package.price,
        currency: 'eur',
        quantity: 1
      }],
      success_url: order_url(order),
      cancel_url: order_url(order)
    )

    order.update(checkout_session_id: session.id)
    redirect_to new_order_payment_path(order)
  end
end
