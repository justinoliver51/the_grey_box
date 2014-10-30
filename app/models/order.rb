class Order < ActiveRecord::Base
    has_and_belongs_to_many :products
    belongs_to :account
    accepts_nested_attributes_for :account

    validates :price, :status, presence: true
    validates :price, numericality: { greater_than: 0}
    validates :transaction_id, numericality: { greater_than_or_equal_to: 0}
    validates_inclusion_of :status, :in => ["PURCHASE_PENDING", "PURCHASED", "REFUND_PENDING", "REFUNDED"], :allow_nil => false
end
