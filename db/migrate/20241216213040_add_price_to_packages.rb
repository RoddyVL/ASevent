class AddPriceToPackages < ActiveRecord::Migration[7.1]
  def change
    # Vérifier si la colonne n'existe pas déjà avant de l'ajouter
    unless column_exists?(:packages, :price_cents)
      add_monetize :packages, :price, currency: { present: false }
    end
  end
end
