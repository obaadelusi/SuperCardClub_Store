# require 'pp'

class CheckoutController < ApplicationController

  def index
    @provinces = Province.all.map { |p| [p.name, p.id] }
    @provinces_tax_rates = Province.all.map { |p| { 'id' => p.id, 'gst' => p.gst, 'pst' => p.pst, 'hst' => p.hst} }

    if(cart.empty?)
      redirect_to cart_index_path
      return
    end
  end

  # create payment checkout with stripe
  def create

  end

  # on payment success
  def success
    redirect_to orders_path
  end

  # on payment cancel
  def cancel
    redirect_to checkout_index_path
  end

end
