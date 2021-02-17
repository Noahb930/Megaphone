class NumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.location == "NY State Senate"
      if value.match(/^S|A\d+$/)
        connection = Faraday.new(
          url: "https://v3.openstates.org",
          headers: {"X-API-KEY" => ENV["OPEN_STATES_API_KEY"]},
        )
        res = connection.get("bills/New%20York/#{record.session.to_i}-#{record.session.to_i+1}/#{value}")
        unless JSON.parse(res.body).key?("id")
          record.errors.add(attribute, "does not reference an existing bill")
        end
      else
          record.errors.add(attribute, "is not valid")
      end
    elsif record.location == "US House" || record.location == "US Senate"
      if value.match(/^(S|HR)\d+$/)
        res = Faraday.get("https://api.propublica.org/congress/v1/#{(record.session.to_i-1787)/2}/bills/#{value}.json") do |req|
          req.headers["X-API-Key"] = ENV["PROPUBLICA_API_KEY"]
        end
        unless JSON.parse(res.body)["results"].present?
          record.errors.add(attribute, "does not reference an existing bill")
        end
      else
        record.errors.add(attribute, "is not valid")
      end
    end
  end
end
