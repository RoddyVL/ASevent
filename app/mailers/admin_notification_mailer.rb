class AdminNotificationMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def new_booking_notification(booking)
    @booking = booking
    admins = User.where(admin: true).pluck(:email)
    mail(to: admins, subject: "Nouvelle réservation créée")
  end
end
