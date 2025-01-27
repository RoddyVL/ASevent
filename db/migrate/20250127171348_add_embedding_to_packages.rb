class AddEmbeddingToPackages < ActiveRecord::Migration[7.1]
  def change
    add_column :packages, :embedding, :vector, limit: 1536
  end
end
