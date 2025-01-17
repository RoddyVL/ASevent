class AddDefaultPaimentStatusToBooking < ActiveRecord::Migration[7.1]
  def change
    change_column_default :bookings, :paiement_status, 0
  end
end
