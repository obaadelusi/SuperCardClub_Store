class AlignmentsController < ApplicationController
  before_action :set_alignment, only: %i[ show edit update destroy ]

  # GET /alignments or /alignments.json
  def index
    @alignments = Alignment.all
  end

  # GET /alignments/1 or /alignments/1.json
  def show
  end

  # GET /alignments/new
  def new
    @alignment = Alignment.new
  end

  # GET /alignments/1/edit
  def edit
  end

  # POST /alignments or /alignments.json
  def create
    @alignment = Alignment.new(alignment_params)

    respond_to do |format|
      if @alignment.save
        format.html { redirect_to alignment_url(@alignment), notice: "Alignment was successfully created." }
        format.json { render :show, status: :created, location: @alignment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @alignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /alignments/1 or /alignments/1.json
  def update
    respond_to do |format|
      if @alignment.update(alignment_params)
        format.html { redirect_to alignment_url(@alignment), notice: "Alignment was successfully updated." }
        format.json { render :show, status: :ok, location: @alignment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @alignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alignments/1 or /alignments/1.json
  def destroy
    @alignment.destroy!

    respond_to do |format|
      format.html { redirect_to alignments_url, notice: "Alignment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alignment
      @alignment = Alignment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def alignment_params
      params.require(:alignment).permit(:name)
    end
end
