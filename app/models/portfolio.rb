class Portfolio < ApplicationRecord
  belongs_to :user
  has_many :coins, dependent: :destroy
  has_many :transactions, dependent: :destroy
  validates :name, presence: true, uniqueness: true
end
