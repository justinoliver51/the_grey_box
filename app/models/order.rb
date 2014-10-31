class Order < ActiveRecord::Base
  has_and_belongs_to_many :products
  belongs_to :account
  accepts_nested_attributes_for :account

  validates :price, :status, presence: true
  validates :price, numericality: { greater_than: 0}
  validates :transaction_id, numericality: { greater_than_or_equal_to: 0}
  validates_inclusion_of :status, :in => ["PURCHASE_PENDING", "PURCHASED", "REFUND_PENDING", "REFUNDED"], :allow_nil => false

  serialize :notification_params, Hash
  def paypal_url(return_path)
    values = {
      business: "merchant@krevlonventuresllc.com",
      cmd: "_cart",
      upload: 1,
      return: "#{Rails.application.secrets.app_host}#{return_path}",
      notify_url: "#{Rails.application.secrets.app_host}/hook",
      invoice: id
  	}

  	# Create an array of items 
    suffix = 1
    products.each do |product|
	  values["item_name_#{suffix}"] 	= product.name
	  values["item_number_#{suffix}"] 	= product.id
	  values["amount_#{suffix}"] 		= product.price
	  values["shipping_#{suffix}"] 		= 2.50
	  values["tax_#{suffix}"] 			= '%.2f' % (0.08 * product.price)

	  suffix += 1
  	end
    "#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" + values.to_query
  end
end
