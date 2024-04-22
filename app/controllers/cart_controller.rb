class CartController < ApplicationController
  before_action :set_character, only: %i[ create destroy update_cart_item ]

  def index
    character_ids = []
    if !cart.empty?
      cart.each { |c|  character_ids << c['character_id'] }
    end

    # Update cart total
    session[:cart_invoice]['subtotal'] = get_cart_total

    @characters = Character.find(character_ids)
  end

  # POST /cart
  def create
    # logger.debug("--> Adding #{params[:id]} to cart.")

    id = params[:character_id].to_i
    quantity = params[:quantity].to_i
    character_name = params[:character_name]
    # character_image = params[:character_image]
    price = @character.price
    on_sale = @character.on_sale

    # Add item to cart or update quantity if item already exists
    if (i = session[:cart].find_index { |c| c['character_id'] == id })
      session[:cart][i]['quantity'] += quantity
    else
      session[:cart] << {
        'character_id' => id,
        'name' => character_name,
        'quantity' => quantity,
        'price' => price,
        'on_sale' => on_sale
      }
    end

    flash[:notice] = "You added #{quantity} \"#{@character.name}\" cards  to your cart."

    redirect_to character_path(@character)
  end

  # POST /update_cart_item
  def update_cart_item
    character_id = params["character_id"].to_i
    new_quantity = params["quantity"].to_i

    logger.debug("--> Updating #{character_id} with qty #{new_quantity}.")

    session[:cart].each do |c|
      if c['character_id'] == character_id
        c['quantity'] = new_quantity
        break
      end
    end

    flash[:notice] = "You updated \"#{@character.name}\" quantity to #{new_quantity}."

    redirect_to cart_index_path
  end

  # DELETE /cart
  def destroy
    id = params[:character_id].to_i

    # Remove item from cart
    session[:cart]&.reject! { |c| c['character_id'] == id }

    flash[:notice] = "\"#{@character.name}\" was removed from cart."
    redirect_to cart_path
  end

  private
  def set_character
    @character = Character.find(params[:character_id])
  end

  def get_cart_total
    cart_total = 0
    for item in session[:cart]
      item_subtotal = item['price'].to_f * item['quantity'].to_f
      cart_total += item_subtotal
    end

    cart_total
  end
end
