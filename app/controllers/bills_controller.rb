require 'net/http'
require 'json'
require 'dotenv/load'
class BillsController < ApplicationController
  before_action :set_bill, only: [:show, :edit, :update, :destroy]

  # GET /bills
  # GET /bills.json
  def index
    @bills = Bill.all
  end

  # GET /bills/1
  # GET /bills/1.json
  def show
    year = 2019
    bill_num = "hr3180"
  end

  # GET /bills/new
  def new
    @bill = Bill.new
  end

  # GET /bills/1/edit
  def edit
  end

  # POST /bills
  # POST /bills.json
  def create
    @bill = Bill.new(bill_params)
    @bill.save

    params["issue_ids"].each do |issue_id|
      @billissue = BillIssue.new(bill_id:@bill.id,issue_id:issue_id)
    end

    professions = {"US Senate"=>"US Senator", "US House"=>"US House Member"}

    if @bill.location == "NYC City Council"
      connection = Faraday.new(
        url: "https://webapi.legistar.com/v1/nyc",
        params: {"token" => ENV["NYC_LEGISTAR_API_KEY"]}) do |f|
        f.request :url_encoded
      end
      res = connection.get("matters") do |req|
        req.params["$filter"] = "MatterEnactmentNumber eq '#{@bill.session}/#{@bill.number}'"
      end
      matter_id = JSON.parse(res.body)[0]['MatterId']
      res = connection.get("matters/#{matter_id}/histories") do |req|
        req.params["$filter"] = "MatterHistoryActionName eq 'Approved by Council'"
      end
      event_id = JSON.parse(res.body)[0]["MatterHistoryEventId"]
      res = connection.get("events/#{event_id}/EventItems") do |req|
        req.params["$filter"] = "EventItemMatterId eq #{matter_id}"
      end
      eventitem_id= JSON.parse(res.body)[-1]["EventItemId"]
      pp JSON.parse(res.body)
      p eventitem_id
      res = connection.get("EventItems/#{eventitem_id}/votes")
      pp JSON.parse(res.body)
      JSON.parse(res.body).each do |vote|
        res = connection.get("persons/#{vote["VotePersonId"]}")
        person = JSON.parse(res.body)
        if person["PersonActiveFlag"]
          pp person["PersonWWW"].scan(/\d+/)[0].to_i
        end
      end
    end
    if @bill.location == "NY State Senate"
      connection = Faraday.new(
        url: "https://legislation.nysenate.gov/api/3",
        params: {"key" => ENV["OPEN_LEGISLATION_API_KEY"]}
      )
      res = connection.get("bills/#{@bill.session}/#{@bill.number}")
      bill = JSON.parse(res.body)['result']

      bill['votes']['items'][-1]["memberVotes"]["items"].each do |vote,voters|
        voters["items"].each do |rep|
          if rep["incumbent"]
            begin
              @rep = Representative.where(district: "District #{rep["districtCode"]}", profession:"NY State Senator")[0]
              @vote = Vote.new(stance:vote.titleize,bill_id:@bill.id,representative_id:@rep.id)
              @vote.save
            rescue NoMethodError => e
            end
          end
        end
      end
    end
    if @bill.location == "US House" || @bill.location == "US Senate"
      connection = Faraday.new(
        url: "https://api.propublica.org/congress/v1",
        headers: {"X-API-Key" => ENV["PROPUBLICA_API_KEY"]}
      )
      res = connection.get("#{(@bill.session.to_i-1787)/2}/bills/#{@bill.number}.json")
      vote = JSON.parse(res.body)["results"][0]["votes"].select { |v|  v["question"].include? "On Passage"  }[0]
      res = connection.get("#{(@bill.session.to_i-1787)/2}/#{vote["chamber"]}/sessions/#{2-(@bill.session.to_i%2)}/votes/#{vote["roll_call"]}.json")
      JSON.parse(res.body)["results"]["votes"]["vote"]["positions"].each do |rep|
        if rep["state"] == "NY"
          res = connection.get("members/#{rep["member_id"]}.json")
          if JSON.parse(res.body)["results"][0]["in_office"]
            @rep = Representative.where(name: rep["name"], profession:professions[@bill.location])
            @vote = Vote.new(stance:rep["vote_position"],bill_id:@bill.id,representative_id:@rep.id)
            @vote.save
          end
        end
      end
    end
  end

  # PATCH/PUT /bills/1
  # PATCH/PUT /bills/1.json
  def update
    respond_to do |format|
      if @bill.update(bill_params)
        format.html { redirect_to @bill, notice: 'Bill was successfully updated.' }
        format.json { render :show, status: :ok, location: @bill }
      else
        format.html { render :edit }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1
  # DELETE /bills/1.json
  def destroy
    @bill.destroy
    respond_to do |format|
      format.html { redirect_to bills_url, notice: 'Bill was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bill
      @bill = Bill.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bill_params
      params.require(:bill).permit(:number, :session, :summary, :endorsed, :location, :name)
    end
end
