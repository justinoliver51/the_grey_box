class CreateJoinTableInvoicesProducts < ActiveRecord::Migration
  def change
    create_table :orders_products, :id => false do |t|
      t.references :order, :product
    end
    
    add_index :orders_products, [:order_id, :product_id]
  end
end
