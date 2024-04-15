class CharactersController < ApplicationController
  before_action :set_character, only: %i[ show edit update destroy ]

  # GET /characters or /characters.json
  def index
    filter = params[:filter].present? ? params[:filter] : ''
    is_query = session[:search_params].present? || params[:q].present?

    if is_query
      keyword = "%#{session[:search_params] || params[:q]}%"
      @characters = Character.where("name LIKE ? OR description LIKE ?", keyword, keyword).order(Arel.sql("CASE WHEN name LIKE '#{keyword}' THEN 0 ELSE 1 END"))
      .page(params[:page]).per(9)
      @characters_count = @characters.count
      session.delete(:search_params)
    else
      case filter
      when 'onSale'
        @characters = Character.where(on_sale: filter).page(params[:page]).per(11)
        @characters_count = Character.where(on_sale: filter).count
      when 'new'
        @characters = Character.where("created_at >= ?", 3.days.ago).page(params[:page]).per(11)
        @characters_count = Character.where("created_at >= ?", 3.days.ago).count
      else
        @characters = Character.order("RANDOM()").page(params[:page]).per(25)
        @characters_count = Character.order("RANDOM()").all.count
      end
    end
  end

  # GET /characters/1 or /characters/1.json
  def show
  end

  # GET /characters/new
  def new
    @character = Character.new
  end

  # GET /characters/1/edit
  def edit
  end

  # POST /characters or /characters.json
  def create
    @character = Character.new(character_params)

    respond_to do |format|
      if @character.save
        format.html { redirect_to character_url(@character), notice: "Character was successfully created." }
        format.json { render :show, status: :created, location: @character }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @character.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /characters/1 or /characters/1.json
  def update
    respond_to do |format|
      if @character.update(character_params)
        format.html { redirect_to character_url(@character), notice: "Character was successfully updated." }
        format.json { render :show, status: :ok, location: @character }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @character.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /characters/1 or /characters/1.json
  def destroy
    @character.destroy!

    respond_to do |format|
      format.html { redirect_to characters_url, notice: "Character was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_character
      @character = Character.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def character_params
      params.require(:character).permit(:name, :description, :on_sale, :price, :stat_combat, :stat_durability, :stat_intelligence, :stat_power, :stat_speed, :stat_strength, :image)
    end
end
