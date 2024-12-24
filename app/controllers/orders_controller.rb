class OrdersController < ApplicationController
  def show
    @order = current_user.orders.find(params[:id])
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
