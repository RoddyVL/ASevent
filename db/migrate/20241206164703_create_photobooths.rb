class CreatePhotobooths < ActiveRecord::Migration[7.1]
  def change
    create_table :photobooths do |t|
      t.string :name
      t.text :description
      t.string :image_url
      t.string :review

      t.timestamps
    end
  end
end
