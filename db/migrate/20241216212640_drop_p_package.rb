class DropPPackage < ActiveRecord::Migration[7.1]
  def change
    drop_table :p_orders
  end
end
