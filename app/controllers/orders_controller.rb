class OrdersController < ApplicationController
  def create
    package = Package.find(params[:package_id])
    booking = Booking.find(params[:booking_id])
    order = Order.create!(
      state: 'pending',
      booking_sku: booking.sku,
      checkout_session_id: nil, # This will be updated after creating the Stripe session
      amount_cents: package.price_cents,
      user: current_user,
      package: package,
      booking: booking
    )

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'eur',
          product_data: {
            name: package.hour,
          },
          unit_amount: package.price_cents
        },
        quantity: 1
      }],
      mode: 'payment',
      success_url: order_url(order),
      cancel_url: order_url(order)
    )

    order.update(checkout_session_id: session.id)
    redirect_to new_order_payment_path(order)
  end
end
