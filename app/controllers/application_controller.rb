class ApplicationController < ActionController::Base
  before_action :initialize_session
  helper_method :cart
  helper_method :cart_invoice

  private
  def initialize_session
    session[:cart] ||= []
    session[:cart_invoice] ||= {}
  end

  def cart
    session[:cart]
  end

  def cart_invoice
    session[:cart_invoice]
  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :street, :city, :province_id, :country, :postal_code])

  end
end
