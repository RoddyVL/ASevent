class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :state
      t.string :booking_sku
      t.string :checkout_session_id
      t.monetize :amount, currency: { present: false }
      t.references :user, null: false, foreign_key: true
      t.references :package, null: false, foreign_key: true
      t.references :booking, null: false, foreign_key: true

      t.timestamps
    end
  end
end
