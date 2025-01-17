class ChangePaiementStatusDefaultAndNullFalseInBookings < ActiveRecord::Migration[7.1]
  def change
    change_column_null :bookings, :paiement_status, false
  end
end
