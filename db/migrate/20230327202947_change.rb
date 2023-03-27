class Change < ActiveRecord::Migration[7.0]
  def change
    change_column :coins, :stock, :decimal
    change_column :transactions, :amount_in, :decimal
    change_column :transactions, :amount_out, :decimal
    change_column :transactions, :amount_fees, :decimal
  end
end
