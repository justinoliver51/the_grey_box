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

    #@account.save
    if @order.save
      #@order.account = @account

      # Get the products that were selected
      price = 0
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

      @order.update(price: price)

      redirect_to root_path
      #redirect_to product_orders_path(@product, @order)
      #redirect_to @order.paypal_url(registration_path(@order))
    else
      render :new
    end
  end

  protect_from_forgery except: [:hook]
  def hook
    params.permit! # Permit all Paypal input params
    status = params[:payment_status]
    if status == "Completed"
      @order = Registration.find params[:invoice]
      @order.update_attributes notification_params: params, status: status, transaction_id: params[:txn_id], purchased_at: Time.now
    end
    render nothing: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:products, account_attributes: [:street, :city, :state, :full_name, :email])
    end
end
