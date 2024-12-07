class CreatePackages < ActiveRecord::Migration[7.1]
  def change
    create_table :packages do |t|
      t.time :hour
      t.integer :price
      t.time :overtime
      t.references :photobooth, null: false, foreign_key: true

      t.timestamps
    end
  end
end
