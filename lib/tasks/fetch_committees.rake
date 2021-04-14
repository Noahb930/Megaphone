require 'byebug'
require 'watir'
require 'nokogiri'
namespace :fetch_committees do
  task ny_legislature: :environment do
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
    ["NY State Senator","NY State Assembly Member"].each do |profession|
        Representative.where(profession:profession).each do |rep|
        name = rep.name
        name.gsub!(/(?<= )[A-Z]\.? /,'')
        name.gsub!(/ I{2,}/,'')
        name.gsub!(/ Jr\.?/,'')
        name.gsub!(/ Sr\.?/,'')
        response = connection.post(
            "CandidateCommitteeDisclosure/AutoCompleteFIDASCandidate",
            {"term":rep.name,"officeType":10,"searchby":"Candidate","status":"All","county":"","municipality":""}.to_json
        )
        if response.status == 200
          profession = {"NY State Senator":"State Senator","NY State Assembly Member":"Member of Assembly"}[profession]
          candidate = JSON.parse(response.body).grep(/#{profession}/)[0]
          if candidate != nil
            committees = []
            tries = 0
            while committees == []
                response = connection.post(
                "CandidateCommitteeDisclosure/GetCommitteesData",
                {"txtName":"CANDIDATE","txtNameValue":candidate,"listReportsSearchBy":"Candidate"}.to_json
                )
                committees = JSON.parse(response.body)
                tries +=1
                if tries == 9
                    p "Committee not found for "+name
                    break
                end
            end
            committees.each do |committee|
                filer_id = committee["CommitteeId"]
                name = committee["CommitteeName"].split("-")[0].strip
                obj = Committee.new("filer_id":filer_id,"name":name,"representative_id":rep.id)
                obj.save
            end
          else
            p "Candidate not found for "+name
          end
        end
      end
    end
  end
end
