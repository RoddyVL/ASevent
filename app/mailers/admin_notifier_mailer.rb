class AdminNotifierMailer < ApplicationMailer
  # default from: 'notifications@example.com' # Remplace par l'adresse souhaitée

  def new_booking_notification(booking)
    @booking = booking
    mail(
      to: 'rodrodvellayoudom@hotmail.com', # Envoie à tous les administrateurs
      subject: 'Nouvelle réservation créée'
    )
  end
end
