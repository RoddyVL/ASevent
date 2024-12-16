class RemoveForeignKeyFromPOrders < ActiveRecord::Migration[7.1]
    def change
      remove_foreign_key :p_orders, :p_bookings
    end
end
