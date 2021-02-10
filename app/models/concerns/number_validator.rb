class NumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.location == "NY State Senate"
      if value.match(/^S\d+$/)
        res = Faraday.get("https://legislation.nysenate.gov/api/3/bills/#{record.session}/#{value}") do |req|
          req.params['key'] = ENV["OPEN_LEGISLATION_API_KEY"]
        end
        unless JSON.parse(res.body)["results"].present?
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
