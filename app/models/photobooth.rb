class Photobooth < ApplicationRecord
  has_many :packages
  has_many :photos, dependent: :destroy
  has_neighbors :embedding
  after_create :set_embedding


  validates :name, presence: true
  validates :description, presence: true

  private

  def set_embedding
    client = OpenAI::Client.new
    response = client.embeddings(
      parameters: {
        model: 'text-embedding-3-small',
        input: "Photobooth: #{name}. Description: #{description}"
      }
    )
    embedding = response['data'][0]['embedding']
    update(embedding: embedding)

    # Set embeddings for packages
    packages.each(&:set_embedding)
  end
end
