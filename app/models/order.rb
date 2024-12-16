class Order < ApplicationRecord
  belongs_to :user
  belongs_to :package
  belongs_to :booking

  monetize :amount_cents
  enum state: { pending: 0, paid: 1 }
end
