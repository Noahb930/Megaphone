require 'net/http'
require 'json'
require 'dotenv/load'
class BillsController < ApplicationController
  before_action :set_bill, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!

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
    if @bill.save
      professions = {"US Senate"=>"US Senator", "US House"=>"US House Member", "NY State Senate"=>"NY State Senator", "NY State Assembly"=>"NY State Assembly Member"}
      if @bill.location == "NY State Senate" || @bill.location == "NY State Assembly"
        connection = Faraday.new(
          url: "https://v3.openstates.org",
          headers: {"X-API-KEY" => ENV["OPEN_STATES_API_KEY"]},
        )
        res = connection.get("bills/New%20York/2019-2020/S2451") do |req|
          req.options.params_encoder = Faraday::FlatParamsEncoder
          req.params["include"] = ["votes"]
        end
        JSON.parse(res.body)["votes"][0]["votes"].each do |vote|
          @rep = Representative.where(name: vote["voter_name"], profession:professions[@bill.location])[0]
          @vote = Vote.new(stance:rep["option"],bill_id:@bill.id,representative_id:@rep.id)
          @vote.save
        end
      elsif @bill.location == "US House" || @bill.location == "US Senate"
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
              @rep = Representative.where(name: rep["name"], profession:professions[@bill.location])[0]
              @vote = Vote.new(stance:rep["vote_position"],bill_id:@bill.id,representative_id:@rep.id)
              @vote.save
            end
          end
        end
      end
      redirect_to bills_url, notice: 'Bill was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /bills/1
  # PATCH/PUT /bills/1.json
  def update
    respond_to do |format|
      if @bill.update(bill_params)
        format.html { redirect_to bills_url, notice: 'Bill was successfully updated.' }
        format.json { render :index, status: :ok, location: @bill }
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
      params.require(:bill).permit(:number, :session, :summary, :endorsed, :location, :name, issue_ids:[])
    end
end
