class CreateCoins < ActiveRecord::Migration[7.0]
  def change
    create_table :coins do |t|
      t.string :gecko_coin
      t.string :symbol
      t.string :name
      t.float :stock
      t.float :price
      t.float :change
      t.integer :market_cap_rank
      t.string :image_url
      t.references :portfolio, null: false, foreign_key: true

      t.timestamps
    end
  end
end
