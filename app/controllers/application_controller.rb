class ApplicationController < ActionController::Base
  before_action :set_stripe_key
  before_action :set_browser

  private

  def set_browser
    @browser = Browser.new(request.user_agent)
    @is_mobile = @browser.device.mobile?
  end

  def set_stripe_key
    @stripe_public_key = ENV['STRIPE_PUBLIC_KEY']
  end
end
