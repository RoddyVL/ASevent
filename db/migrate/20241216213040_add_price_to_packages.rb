class AddPriceToPackages < ActiveRecord::Migration[7.1]
  def change
    add_monetize :packages, :price, currency: {present: false}
  end
end
