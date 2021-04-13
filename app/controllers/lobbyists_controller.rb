require 'watir'
require 'nokogiri'

class LobbyistsController < ApplicationController
  before_action :set_lobbyist, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!

  # GET /lobbyists
  # GET /lobbyists.json
  def index
    @lobbyists = Lobbyist.all
  end

  # GET /lobbyists/1
  # GET /lobbyists/1.json
  def show
  end

  # GET /lobbyists/new
  def new
    @lobbyist = Lobbyist.new
  end

  # GET /lobbyists/1/edit
  def edit
  end

  # POST /lobbyists
  # POST /lobbyists.json
  def create
    @lobbyist = Lobbyist.new(lobbyist_params)

    respond_to do |format|
      if @lobbyist.save
        browser = Watir::Browser.new :chrome, headless: true 
        browser.goto("https://publicreporting.elections.ny.gov/CandidateCommitteeDisclosure/CandidateCommitteeDisclosure")
        cookie = browser.cookies.to_a.map {|cookie| "#{cookie[:name]}=#{cookie[:value]}"}.join("\; ")
        connection = Faraday.new(
          url: "https://publicreporting.elections.ny.gov/",
          headers: {
            "datatype" => "json",
            "content-type" => "application/json",
            "cookie" => cookie,
            "Connection": "keep-alive"
          }
        )
        response = connection.post(
          "CandidateCommitteeDisclosure/GetFilingInventoryData/",
          {"strFilerId":@lobbyist.filer_id,"officeType":10,"searchby":"FILER"}.to_json
        )
        if response.status == 200
          filings = []
          while filings == []
            response = connection.get(
              "CandidateCommitteeDisclosure/CandidateCommitteeDisclosure"
            )
            html = Nokogiri::HTML(response.body)
            filings = html.css(".lnkFilingInventory").map {|link| 
              {
                "filing_ID": link['id'].split('-')[1],
                "submit_Date": link.text.strip.split(" ")[1..-1].join(" ")
              }
            }
          end
          filings.each do |filing|
            response = connection.post(
              "CandidateCommitteeDisclosure/GetSearchCandidateCommitteeData/",filing.to_json
            )
            if response.status == 200
              JSON.parse(response.body)["aaData"].each do |row|
                if row[2] == "F - Expenditures/ Payments"
                  committee = Committee.where(name:row[4])[0]
                  if committee
                    contribution = Contribution.new(
                      :amount => row[8].gsub(/[$,]/,'').to_i,
                      :date => Date.strptime(row[3], "%m/%d/%Y"),
                      :representative_id => committee.representative_id,
                      :lobbyist_id => @lobbyist.id)
                    contribution.save
                  end                
                end
              end
            end
          end
        end
        format.html { redirect_to @lobbyist, notice: 'Lobbyist was successfully created.' }
        format.json { render :show, status: :created, location: @lobbyist }
      else
        format.html { render :new }
        format.json { render json: @lobbyist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lobbyists/1
  # PATCH/PUT /lobbyists/1.json
  def update
    respond_to do |format|
      if @lobbyist.update(lobbyist_params)
        format.html { redirect_to @lobbyist, notice: 'Lobbyist was successfully updated.' }
        format.json { render :show, status: :ok, location: @lobbyist }
      else
        format.html { render :edit }
        format.json { render json: @lobbyist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lobbyists/1
  # DELETE /lobbyists/1.json
  def destroy
    @lobbyist.destroy
    respond_to do |format|
      format.html { redirect_to lobbyists_url, notice: 'Lobbyist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lobbyist
      @lobbyist = Lobbyist.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def lobbyist_params
      params.require(:lobbyist).permit(:name, :description, :filer_id)
    end
end
