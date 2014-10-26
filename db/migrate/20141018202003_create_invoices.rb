class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :transaction_id
      t.decimal :price
      t.string :status
      t.integer :account_id

      t.timestamps
    end
  end
end
