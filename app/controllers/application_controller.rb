class ApplicationController < ActionController::Base
  before_action :set_stripe_key
  @is_mobile = browser.device.mobile?

  private

  def set_stripe_key
    @stripe_public_key = ENV['STRIPE_PUBLIC_KEY']
  end
end
