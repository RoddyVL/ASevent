class AddNewFieldToBooking < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :postal_code, :string, null: false, default: ''
    add_column :bookings, :city, :string, null: false, default: ''
  end
end
