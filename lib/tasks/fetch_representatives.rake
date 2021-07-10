namespace :fetch_representatives do

  task nyc_council: :environment do
    connection = Faraday.new(
      url: "https://webapi.legistar.com/v1/nyc",
      params: {"token" => ENV["NYC_LEGISTAR_API_KEY"]}) do |f|
      f.request :url_encoded
    end
    res = connection.get("persons") do |req|
      req.params["$filter"] = "PersonActiveFlag eq 1 and PersonWWW ne ''  and PersonWWW ne null"
    end
    JSON.parse(res.body).each do |person|
      pp person
    #   res = connection.get("persons") do |req|
    #     req.params["$filter"] = "PersonActiveFlag eq 1"
    #   end
    end
  end

  # task ny_senate: :environment do
  #   connection = Faraday.new(
  #     url: "https://legislation.nysenate.gov/api/3",
  #     params: {"key" => ENV["OPEN_LEGISLATION_API_KEY"]}
  #   )
  #   res = connection.get("members/2019/senate") do |req|
  #     req.params["limit"] = 1000
  #     req.params["full"] = true
  #   end
  #   JSON.parse(res.body)['result']['items'].each do |rep|
  #     pp rep
  #     # representative = Representative.new(name: rep["fullName"], district: "District #{rep["districtCode"]}", profession: "NY State Senator", rating:"?", img:"")
  #     # representative.save!
  #   end
  # end
  task ny_senate: :environment do
    connection = Faraday.new(
      url: "https://v3.openstates.org",
      headers: {"X-API-KEY" => ENV["OPEN_STATES_API_KEY"]},
    )
    [1,2].each do |page|
      res = connection.get("people") do |req|
        req.params["jurisdiction"] = "New York"
        req.params["org_classification"] = "upper"
        req.params["per_page"] = 50
        req.params["page"] = page
      end
      JSON.parse(res.body)['results'].each_with_index do |rep, i|
        representative = Representative.new(name: rep["name"], party: "(#{rep['party'][0]})", district: "District #{rep["current_role"]["district"]}", profession: "NY State Senator", rating:"?", img:rep["image"],email:rep["email"].split(";")[0])
        representative.save!
      end
    end
  end
  task ny_assembly: :environment do
    connection = Faraday.new(
      url: "https://v3.openstates.org",
      headers: {"X-API-KEY" => ENV["OPEN_STATES_API_KEY"]},
    )
    [1,2,3].each do |page|
      res = connection.get("people") do |req|
        req.params["jurisdiction"] = "New York"
        req.params["org_classification"] = "lower"
        req.params["per_page"] = 50
        req.params["page"] = page
      end
      JSON.parse(res.body)['results'].each_with_index do |rep, i|
        representative = Representative.new(name: rep["name"], party: "(#{rep['party'][0]})", district: "District #{rep["current_role"]["district"]}", profession: "NY State Assembly Member", rating:"?", img:rep["image"],email:rep["email"].split(";")[0])
        representative.save!
      end
    end
  end

  task us_senate: :environment do
    res = Faraday.get "https://api.propublica.org/congress/v1/117/senate/members.json" do |req|
      req.headers["X-API-Key"] = ENV["PROPUBLICA_API_KEY"]
    end
    JSON.parse(res.body)["results"][0]["members"].each do |rep|
      if rep["state"] == "NY"
        representative = Representative.new(name: [rep["first_name"],rep["last_name"]].join(" "), party: "(#{rep["party"]})", district: nil, profession: "US Senator", img: "https://theunitedstates.io/images/congress/original/#{rep["id"]}.jpg", fec_id: rep["fec_candidate_id"], rating:"?")
        representative.save!
      end
    end
  end

  task us_house: :environment do
    res = Faraday.get "https://api.propublica.org/congress/v1/117/house/members.json" do |req|
      req.headers["X-API-Key"] = ENV["PROPUBLICA_API_KEY"]
    end
    JSON.parse(res.body)["results"][0]["members"].each do |rep|
      if rep["state"] == "NY"
        representative = Representative.new(name: [rep["first_name"],rep["middle_name"],rep["last_name"]].reject(&:blank?).join(" "), party: "(#{rep["party"]})", district: "District #{rep["district"]}", profession: "US House Member", img: "https://theunitedstates.io/images/congress/original/#{rep["id"]}.jpg", fec_id: rep["fec_candidate_id"], rating:"?")
        representative.save!
      end
    end
  end
end
