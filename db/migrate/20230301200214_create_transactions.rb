class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :portfolio, null: false, foreign_key: true
      t.date :date
      t.references :coin_in, foreign_key: { to_table: :coins }
      t.float :amount_in
      t.float :amount_in_euro
      t.float :amount_in_btc
      t.references :coin_out, foreign_key: { to_table: :coins }
      t.float :amount_out
      t.float :amount_out_euro
      t.float :amount_out_btc
      t.references :coin_fees, foreign_key: { to_table: :coins }
      t.float :amount_fees
      t.float :amount_fees_euro
      t.float :amount_fees_btc
      t.timestamps
    end
  end
end
