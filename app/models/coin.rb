class Coin < ApplicationRecord
  belongs_to :portfolio
  validates :gecko_coin, presence: true,
                         uniqueness: { scope: :portfolio, message: "this coin is already in your portfolio" },
                         confirmation: true
  belongs_to :coin_in,   class_name: "Transaction", optional: true
  belongs_to :coin_out,  class_name: "Transaction", optional: true
  belongs_to :coin_fees, class_name: "Transaction", optional: true
end
