class RenameAdressToAddressInBookings < ActiveRecord::Migration[7.1]
  def change
    rename_column :bookings, :adress, :address
  end
end
