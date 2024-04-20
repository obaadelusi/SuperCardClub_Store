class ApplicationController < ActionController::Base
  before_action :initialize_session
  helper_method :cart

  private
  def initialize_session
    session[:cart] ||= []
  end

  def cart
    character_ids = []
    session[:cart].each { |c|  character_ids << c['character_id'] }

    logger.debug("--> character_ids: #{character_ids} in db.")

    Character.find(character_ids)
  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :street, :city, :province_id, :country, :postal_code])

  end
end
