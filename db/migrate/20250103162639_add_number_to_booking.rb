class AddNumberToBooking < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :phone_number, :string, null: false, default: ''
  end
end
