class BeliefsController < ApplicationController
  before_action :set_belief, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!
  # GET /beliefs
  # GET /beliefs.json
  def index
    @beliefs = Belief.all
  end

  # GET /beliefs/1
  # GET /beliefs/1.json
  def show
  end

  # GET /beliefs/new
  def new
    @belief = Belief.new
    @representative = Representative.find(params[:representative_id])
    respond_to do |format|
      format.js
    end
  end

  # GET /beliefs/1/edit
  def edit
    @belief = Belief.find(params[:id])
    @rep_index = params[:index]
    @representative=Representative.includes(:beliefs).where(beliefs: {id: params[:id]})[0]
    respond_to do |format|
      format.js
    end
  end

  # POST /beliefs
  # POST /beliefs.json
  def create
    @belief = Belief.new(belief_params)
    @index = params[:rep_index]
    p params[:rep_index]
    respond_to do |format|
      if @belief.save
        @representative=Representative.find(@belief.representative_id)
        @partial = "beliefs"
        format.js {render 'representatives/show'}
      else
        format.html { render :new }
        format.json { render json: @belief.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beliefs/1
  # PATCH/PUT /beliefs/1.json
  def update
    respond_to do |format|
      if @belief.update(belief_params)
        @representative=Representative.find(@belief.representative_id)
        @partial = "beliefs"
        format.js {render 'representatives/show'}
      else
        format.html { render :edit }
        format.json { render json: @belief.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beliefs/1
  # DELETE /beliefs/1.json
  def destroy
    @representative=Representative.find(@belief.representative_id)
    @partial = "beliefs"
    @belief.destroy
    respond_to do |format|
      format.js {render 'representatives/show'}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_belief
      @belief = Belief.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def belief_params
      params.require(:belief).permit(:name, :description, :phone, :fax, :address, :representative_id, :issue_id)
    end
end
