class Package < ApplicationRecord
    belongs_to :photobooth
    has_many :bookings, dependent: :destroy
    has_neighbors :embedding
    after_create :set_embedding

    validates :hour, presence: true
    validates :price, presence: true
    monetize :price_cents

    private

    def set_embedding
      client = OpenAI::Client.new
    response = client.embeddings(
      parameters: {
        model: 'text-embedding-3-small',
        input: "Package: #{hour}. Price: #{price}"
      }
    )
    embedding = response['data'][0]['embedding']
    update(embedding: embedding)
    end
end
