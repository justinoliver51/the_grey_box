class Product < ActiveRecord::Base
    has_and_belongs_to_many :orders

    validates :name, :description, :price, presence: true
    validates :price, numericality: { greater_than: 0}
end
