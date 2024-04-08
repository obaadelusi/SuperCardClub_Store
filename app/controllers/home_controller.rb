class HomeController < ApplicationController
  def index
    offset = rand(1...Character.count)
    @character = Character.offset(offset).first
  end
end
