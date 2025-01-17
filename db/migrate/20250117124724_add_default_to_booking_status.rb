class AddDefaultToBookingStatus < ActiveRecord::Migration[7.1]
  def change
    change_column_default :bookings, :booking_status, from: nil, to: 0
    change_column_null :bookings, :booking_status, false
  end
end
