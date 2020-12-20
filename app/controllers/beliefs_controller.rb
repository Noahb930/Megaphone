class BeliefsController < ApplicationController
  before_action :set_belief, only: [:show, :edit, :update, :destroy]

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
    @belief_index =
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
        @representative=Representative.includes(:beliefs).where(beliefs: {id: params[:id]})[0]
        format.js {render 'representatives/admin_beliefs'}
        # format.html { redirect_to @belief, notice: 'belief was successfully created.' }
        # format.json { render :show, status: :created, location: @belief }
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
        format.js {render 'representatives/admin_beliefs'}
      else
        format.html { render :edit }
        format.json { render json: @belief.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beliefs/1
  # DELETE /beliefs/1.json
  def destroy
    @belief.destroy
    respond_to do |format|
      format.html { redirect_to beliefs_url, notice: 'belief was successfully destroyed.' }
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
