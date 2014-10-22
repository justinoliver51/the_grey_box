class CreateJoinTableInvoicesProducts < ActiveRecord::Migration
  def change
    create_table :invoices_products, :id => false do |t|
      t.references :invoice, :product
    end
    
    add_index :invoices_products, [:invoice_id, :product_id]
  end
end
