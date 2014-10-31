class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  def index
    @orders = Order.all
  end

  # GET /orders/1
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
    @order.build_account
    @user = Account.new
    @product = Product.find(params[:product_id])
    @products = Product.all
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  def create
    @product = Product.find(params[:product_id])
    @order = Order.new(order_params)

    # Set up defaults
    @order.status = "PURCHASE_PENDING"
    @order.transaction_id = 0
    @order.price = @product.price
    price = 0

    if @order.save
      # Get the products that were selected
      products = params[:products]
      for key,value in products
        quantity = value["quantity"].to_i
        if quantity > 0
          @product = Product.find(key)
          price += (quantity * @product.price)

          # Adds order_product for each product ordered
          quantity.downto(1) do |i|
            @order.products << @product
          end
        end
      end

      # Update the price
      @order.update(price: price)
      Stripe.api_key = Rails.application.secrets.STRIPE_API_KEY
      token = params[:stripeToken]
      
      # If the token is blank, pay with PayPal
      if token.blank? 
        redirect_to @order.paypal_url(orders_path(@order))
      else
        # Otherwise, pay with Stripe
        begin
          charge = Stripe::Charge.create(
            :amount => (@order.price * 100).floor,
            :currency => "usd",
            :card => token
            )
          # FIXME: Update order here to reflect successful purchase
        rescue Stripe::CardError => e
          flash[:danger] = e.message
        end

        redirect_to root_path
      end
    else
      render :new
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:products, :stripeToken, account_attributes: [:street, :city, :state, :full_name, :email])
    end
end
