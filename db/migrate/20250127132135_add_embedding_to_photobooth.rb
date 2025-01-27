class AddEmbeddingToPhotobooth < ActiveRecord::Migration[7.1]
  def change
    add_column :photobooths, :embedding, :vector, limit: 1536
  end
end
