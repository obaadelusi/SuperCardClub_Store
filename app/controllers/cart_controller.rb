class CartController < ApplicationController
  before_action :set_character, only: %i[ create destroy ]

  def index
    # @characters = cart
  end

  # POST /cart
  def create
    # logger.debug("--> Adding #{params[:id]} to cart.")

    id = params[:character_id].to_i
    quantity = params[:quantity].to_i
    character_name = params[:character_name]
    character_image = params[:character_image]
    # character = Character.find(id)

    # Add item to cart or update quantity if item already exists
    # session[:cart] << id unless session[:cart].include?(id)
    if (index = session[:cart].find_index { |c| c['character_id'] == id })
      session[:cart][index]['quantity'] += quantity
    else
      session[:cart] << { 'character_id' => id,
                          'name' => character_name,
                          'image' => character_image,
                          'quantity' => quantity
                        }
    end

    flash[:notice] = "You added #{quantity} \"#{@character.name}\" cards  to cart."

    redirect_to character_path(@character)
  end

  # POST /update_cart_item
  def update_cart_item
    character_id = params["character_id"].to_i
    new_quantity = params["quantity"].to_i

    session[:cart].each do |c|
      if c['character_id'] == character_id
        c['quantity'] = new_quantity
        break
      end
    end

    redirect_to cart_path
  end

  # DELETE /cart
  def destroy
    id = params[:character_id].to_i

    # Remove item from cart
    # session[:cart].delete(id)
    session[:cart]&.reject! { |c| c['character_id'] == id }
    # character = Character.find(id)

    flash[:notice] = "\"#{@character.name}\" was removed from cart."
    redirect_to cart_path
  end

  private
  def set_character
    @character = Character.find(params[:character_id])
  end
end
