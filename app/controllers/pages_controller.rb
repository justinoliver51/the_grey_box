class PagesController < ApplicationController
  def landing_page
    @products = Product.all
  end

  def index
    @products = Product.all
  end

  def checkout_with_paypal
  	redirect_to paypal_url("pages#checkout") # pages_checkout
  end

  def paypal_url(return_path)
    values = 
    {
      business: "merchant@krevlonventuresllc.com",
      cmd: "_xclick",
      upload: 1,
      return: "#{Rails.application.secrets.app_host}#{return_path}",
      invoice: 0,
      amount: 9.99,
      item_name: "Product Name",
      item_number: "Product ID",
      quantity: '1',
      notify_url: "#{Rails.application.secrets.app_host}/hook"
    }
    "#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" + values.to_query
  end

#  # POST /registrations
#  def create
#    @registration = Registration.new(registration_params)
#    if @registration.save
#      redirect_to @registration.paypal_url(registration_path(@registration))
#    else
#      render :new
#    end
#  end
end
