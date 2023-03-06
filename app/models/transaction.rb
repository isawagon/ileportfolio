class Transaction < ApplicationRecord
  belongs_to :portfolio
  validates :coin_in_id, :amount_in, :coin_out_id, :amount_out, presence: true

end
