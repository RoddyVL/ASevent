class CreateBooking < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.string :adress
      t.date :date
      t.time :time
      t.integer :status
      t.integer :paiement_status
      t.integer :booking_status

      t.references :package, null: false, foreign_key: true  # Clé étrangère vers Package
      t.references :client, null: false, foreign_key: true  # Clé étrangère vers Client

      t.timestamps
    end
  end
end
