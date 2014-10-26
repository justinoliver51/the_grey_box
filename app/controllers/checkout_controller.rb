class CheckoutController < ApplicationController
  def show
  	@order = Order.new
    @account = Account.new
    @product = Product.find(params[:product_id])
  end
end
