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
    @lobbyist.fec_committee_ids = lobbyist_params["fec_committee_ids"].split(",").collect(&:strip)
    @lobbyist.nysboe_committee_ids = lobbyist_params["nysboe_committee_ids"].split(",").collect(&:strip)
    respond_to do |format|
      if @lobbyist.save
        @lobbyist.fec_committee_ids.each do |committee_id|
          last_disbursement_date = nil
          last_index = nil
          while TRUE
            response = Faraday.get 'https://api.open.fec.gov/v1/schedules/schedule_b' do |req|
              req.params["api_key"] = ENV["OPEN_FEC_API_KEY"]
              req.params["committee_id"] = committee_id
              req.params["recipient_state"] = "NY"
              req.params["per_page"] = 100
              req.params["last_disbursement_date"] = last_disbursement_date unless last_disbursement_date.nil?
              req.params["last_index"] = last_index unless last_index.nil?
            end
            if response.status == 200
              body = JSON.parse(response.body)
              if body["results"].length > 0
                last_index = body["pagination"]["last_indexes"]["last_index"]
                last_disbursement_date = body["pagination"]["last_indexes"]["last_disbursement_date"]
                body["results"].each do |entry|
                  unless entry["recipient_committee"].nil?
                    representative = Representative.where(fec_id:entry["recipient_committee"]["candidate_ids"][0]).first
                    unless representative.nil? || entry["disbursement_amount"] < 0
                      contribution = Contribution.new(
                        :amount => entry["disbursement_amount"],
                        :date => Date.parse(entry["disbursement_date"]),
                        :representative_id => representative.id,
                        :lobbyist_id => @lobbyist.id)
                      contribution.save
                    end
                  end
                end
              else
                break
              end
            else
              break
            end
          end
          last_expenditure_date = nil
          last_index = nil
          while TRUE
            response = Faraday.get 'https://api.open.fec.gov/v1/schedules/schedule_e' do |req|
              req.params["api_key"] = ENV["OPEN_FEC_API_KEY"]
              req.params["committee_id"] = "C00053553"
              req.params["candidate_office_state"] = "NY"
              req.params["min_amount"] = 100
              req.params["per_page"] = 100
              req.params["last_expenditure_date"] = last_expenditure_date unless last_expenditure_date.nil?
              req.params["last_index"] = last_index unless last_index.nil?
            end
            if response.status == 200
              body = JSON.parse(response.body)
              if body["results"].length > 0
                last_index = body["pagination"]["last_indexes"]["last_index"]
                last_expenditure_date = body["pagination"]["last_indexes"]["last_expenditure_date"]
                body["results"].each do |entry|
                  representative = Representative.where(fec_id:entry["candidate_id"]).first
                  unless representative.nil?
                    multipliers = {"S"=>1,"O"=>-1}
                    contribution = Contribution.new(
                      :amount => entry["expenditure_amount"] * multipliers[entry["support_oppose_indicator"]],
                      :date => Date.parse(entry["expenditure_date"]),
                      :representative_id => representative.id,
                      :lobbyist_id => @lobbyist.id)
                    contribution.save
                  end
                end
              else
                break
              end
            else
              break
            end
          end
        end
        @lobbyist.nysboe_committee_ids.each do |committee_id|
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
        end
        format.html { redirect_to lobbyists_url, notice: 'Lobbyist was successfully created.' }
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
        format.html { redirect_to lobbyists_url}
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
      params.require(:lobbyist).permit(:name, :description, :fec_committee_ids, :nysboe_committee_ids)
    end
end
