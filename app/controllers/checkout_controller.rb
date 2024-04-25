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

    grand_total = 0

    cart.each do |item|
      character = Character.find(item['character_id'])

      order_item = OrderItem.create!(
        order: order,
        character: character,
        quantity: item['quantity'],
        price: item['price']
      )

      grand_total += (item['price'].to_f * item['quantity'].to_f)
    end

    gst = province.gst ? province.gst * grand_total : 0
    pst = province.pst ? province.pst * grand_total : 0
    hst = province.hst ? province.hst * grand_total : 0

    grand_total += gst + pst + hst

    order.grand_total = grand_total.round(2)
    order.save

    session.delete(:cart)
    session.delete(:cart_invoice)

    redirect_to root_path
  end
end
