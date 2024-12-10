class RemoveClientIdFromBookings < ActiveRecord::Migration[7.1]
  def change
    remove_column :bookings, :client_id, :integer
  end
end
