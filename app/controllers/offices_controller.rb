class OfficesController < ApplicationController
  before_action :set_office, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!
  # GET /offices
  # GET /offices.json
  def index
    @offices = Office.all
  end

  # GET /offices/1
  # GET /offices/1.json
  def show
  end

  # GET /offices/new
  def new
    @office = Office.new
  end

  # GET /offices/1/edit
  def edit
    @office = Office.find(params[:id])
    @representative=Representative.includes(:offices).where(offices: {id: params[:id]})[0]
    respond_to do |format|
      format.js
    end
  end

  # POST /offices
  # POST /offices.json
  def create
    @office = Office.new(office_params)

    respond_to do |format|
      if @office.save
        format.html { redirect_to @office, notice: 'Office was successfully created.' }
        format.json { render :show, status: :created, location: @office }
      else
        format.html { render :new }
        format.json { render json: @office.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /offices/1
  # PATCH/PUT /offices/1.json
  def update
    respond_to do |format|
      if @office.update(office_params)
        @representative=Representative.find(@office.representative_id)
        format.js {render 'representatives/overview'}
      else
        format.html { render :edit }
        format.json { render json: @office.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offices/1
  # DELETE /offices/1.json
  def destroy
    @office.destroy
    respond_to do |format|
      format.html { redirect_to offices_url, notice: 'office was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_office
      @office = Office.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def office_params
      params.require(:office).permit(:name, :description, :phone, :fax, :address)
    end
end
