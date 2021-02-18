require 'geokit'
require 'dotenv'
require 'open-uri'
Dotenv.load
class RepresentativesController < ApplicationController
  before_action :set_representative, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!, except: [:find, :show]
  # GET /representatives
  # GET /representatives.json
  def index
    @representatives = Representative.where(:profession => params[:profession]).order("district ASC")
    p params[:profession]
  end

  def show
    @representative = Representative.find(params[:id])
    @partial = params[:partial]
    respond_to do |format|
      format.js
    end
  end

  def contributions
    @representative = Representative.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  # GET /representatives/new
  def new
    @representative = Representative.new
  end

  # GET /representatives/1/edit
  def edit
    @representative = Representative.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  # POST /representatives
  # POST /representatives.json
  def create
    @representative = Representative.new(representative_params)
    respond_to do |format|
      if @representative.save
        format.html { redirect_to @representative, notice: 'Representative was successfully created.' }
        format.json { render :show, status: :created, location: @representative }
      else
        format.html { render :new }
        format.json { render json: @representative.errors, status: :unprocessable_entity }
      end
    end


  end

  # PATCH/PUT /representatives/1
  # PATCH/PUT /representatives/1.json
  def update
    respond_to do |format|
      if @representative.update(representative_params)
        @partial = "overview"
        format.js {render :show}
      else
        format.html { render :edit }
        format.json { render json: @representative.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /representatives/1
  # DELETE /representatives/1.json
  def destroy
    @representative.destroy
    respond_to do |format|
      format.html { redirect_to representatives_url, notice: 'Representative was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def find
    @reps = []
    results = Geocoder.search([params[:address], params[:city],params[:zipcode]].join(" "))
    if results.empty?
      flash[:error] = "Not a Valid Address"
      redirect_to root_path
    elsif results.first.data["address"]["adminDistrict"] != "NY"
      flash[:error] = "Address is Outside of New York State"
      redirect_to root_path
    else
      latlng = results.first.coordinates
      loc =  Geokit::LatLng.new(latlng[0], latlng[1])
      file_paths = ['city_council_map.json','state_assembly_map.json','state_senate_map.json','us_house_map.json']
      professions = ["NYC City Council Member","NY State Assembly Member","NY State Senator","US House Member"]
      properties = ["coun_dist","district","district","district"]
      [file_paths,professions,properties].transpose.each do |file_path,profession,property|
        file = File.read(file_path).downcase
        map = JSON.parse(file)
        map["features"].each do |feature|
          district = "District " + feature["properties"][property].to_s.sub(/^[0]+/,'')
          if feature["geometry"]["type"] == "polygon"
            points = []
            feature["geometry"]["coordinates"][0].each do |point|
              points << Geokit::LatLng.new(point[1], point[0])
            end
            polygon = Geokit::Polygon.new(points)
            if polygon.contains? loc
              rep = Representative.where(profession:profession).where(district: district).first
              unless rep.nil?
                @reps.push(rep)
              end
              break
            end
          else
            feature["geometry"]["coordinates"][0].each do |shape|
              points = []
              shape.each do |point|
                points << Geokit::LatLng.new(point[1], point[0])
              end
            end
            polygon = Geokit::Polygon.new(points)
            if polygon.contains? loc
              rep = Representative.where(profession:profession).where(district: district).first
              unless rep.nil?
                @reps.push(rep)
              end
              break
            end
          end
        end
      end
      @reps += Representative.where(profession:"US Senator")
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_representative
      @representative = Representative.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def representative_params
      params.require(:representative).permit(:name, :district, :party, :profession, :img, :url, :email, :rating)
    end
end
