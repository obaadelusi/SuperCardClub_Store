class CheckoutController < ApplicationController
  def index
    @provinces = Province.all.map { |p| [p.name, p.id] }
    @provinces_tax_rates = Province.all.map { |p| { 'id' => p.id, 'gst' => p.gst, 'pst' => p.pst, 'hst' => p.hst} }
  end

  def create
    province_id = current_customer.province_id
    province = Province.find(province_id)

    order = Order.create!(
      customer: current_customer,
      status: "new",
      gst: province.gst,
      pst: province.pst,
      hst: province.hst,
    )

    logger.debug("------>> Checkout create: Order #{order.id}, and order items created....")

    cart.each do |item|
      character = Character.find(item['character_id'])

      order_item = OrderItem.create!(
        order: order,
        character: character,
        quantity: item['quantity'],
        price: item['price']
      )
    end

    session.delete(:cart)
    session.delete(:cart_invoice)

    redirect_to root_path
  end
end
