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
    line_items = []

    province_id = current_customer.province_id
    province = Province.find(province_id)

    if(cart.empty? || province.nil?)
      redirect_to root_path
    end

    order = Order.create!(
      customer: current_customer,
      status: "new",
      gst: province.gst,
      pst: province.pst,
      hst: province.hst,
    )

    # used later on payment success
    session[:last_order_id] = order.id

    # for each item in cart
    # 1. update line items for stripe
    # 2. make grand_total
    # 3. save order & order_items to db
    # 4. go to stripe checkout

    grand_total = 0

    cart.each do |item|
      character = Character.find(item['character_id'])

      if(character.nil?)
        redirect_to cart_index_path
        return
      end

      order_item = OrderItem.create!(
        order: order,
        character: character,
        quantity: item['quantity'],
        price: item['price']
      )

      line_items << {
        quantity: order_item.quantity,
          price_data: {
            unit_amount: (order_item.price * 100).to_i,
            currency: "cad",
              product_data: {
                name: order_item.character.name,
                description: order_item.character.description,
              }
          }
      }

      grand_total += (item['price'].to_f * item['quantity'].to_f)
    end

    gst = province.gst ? province.gst * grand_total : 0
    pst = province.pst ? province.pst * grand_total : 0
    hst = province.hst ? province.hst * grand_total : 0

    # add taxes to stripe line items
    if gst != 0
      line_items << {
      quantity: 1,
          price_data: {
            unit_amount: (gst*100).to_i,
            currency: "cad",
              product_data: {
                name: "GST",
                description: "Goods and Services Tax",
              }
          }
    }
    end
    if pst != 0
      line_items << {
        quantity: 1,
            price_data: {
              unit_amount: (pst*100).to_i,
              currency: "cad",
                product_data: {
                  name: "PST",
                  description: "Provincial Sales Tax",
                }
            }
      }
    end
    if hst != 0
      line_items << {
        quantity: 1,
            price_data: {
              unit_amount: (hst*100).to_i,
              currency: "cad",
                product_data: {
                  name: "HST",
                  description: "Harmonized Sales Tax",
                }
            }
      }
    end

    # add grand total to order. Save order
    grand_total += gst + pst + hst

    order.grand_total = grand_total.round(2)
    order.save

    # create stripe session
    puts line_items.to_s

    @session = Stripe::Checkout::Session.create(
			# went to stripe API, looked up sessions, figured it all out..
			payment_method_types: ["card"],
			success_url: checkout_success_url + "?session_id={CHECKOUT_SESSION_ID}",
			cancel_url: checkout_cancel_url,
      mode: "payment",
			line_items: line_items,
      metadata: {
        order_id: order.id
      }
		)

    # redirect_to root_path
    redirect_to @session.url, allow_other_host: true
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
