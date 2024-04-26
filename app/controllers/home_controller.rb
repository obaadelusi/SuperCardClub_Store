class HomeController < ApplicationController
  def index
    session[:search_params] = params[:search]
    if params[:tag] == "characters"
      redirect_to characters_path
    elsif params[:tag] == "publishers"
      redirect_to publishers_path
    elsif params[:tag] == "races"
      redirect_to races_path
    else
      offset = rand(1...Character.count)
      @character = Character.offset(offset).first
      @races = Race.order("RANDOM()").limit(6)
      @alignments = Alignment.all
    end

  end
end
