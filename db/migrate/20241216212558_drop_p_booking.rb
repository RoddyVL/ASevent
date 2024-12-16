class DropPBooking < ActiveRecord::Migration[7.1]
  def change
    drop_table :p_bookings, if_exists: true, force: :cascade
  end
end
