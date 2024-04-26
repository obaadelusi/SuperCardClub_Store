class OrdersController < ApplicationController
  def index
    if current_customer.nil?
      redirect_to new_customer_session_path
      return
    end

    @orders = Order.where(customer_id: current_customer.id).reverse

    if @orders.nil?
      redirect_to new_customer_session_path
      return
    end

    @subtotals = []
    @totals = []

    @orders.each do |o|
      subtotal = 0
      grand_total = 0

      o.order_items.each do |item|
        subtotal += (item.price * item.quantity)
      end
      @subtotals << subtotal

      gst = o.gst ? o.gst * subtotal : 0
      pst = o.pst ? o.pst * subtotal : 0
      hst = o.hst ? o.hst * subtotal : 0

      grand_total += subtotal + gst + pst + hst
      @totals << grand_total
    end
  end
end
