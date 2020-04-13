namespace :scrape do
  require 'nokogiri'
  require 'open-uri'

  task state_senate: :environment do
    @doc = Nokogiri::HTML(URI("https://www.nysenate.gov/senators-committees").open)
    senators = @doc.css(".u-odd, .u-even")
    senators.each do |senator|
      name = senator.css(".nys-senator--name").text
      img = senator.css("img").attr('src')
      party = senator.css(".nys-senator--party").text.strip.gsub("( ","(").gsub(" )",")")
      district = "District "+senator.css(".nys-senator--district").text.split(")")[1].strip.scan(/\d+/)[0]
      url = "https://www.nysenate.gov" +senator.css("a")[0].values[0]
      @doc = Nokogiri::HTML(URI(url+"/contact").open)
      email = @doc.css(".c-block--senator-email a").text
      if email.include? ";"
        email = email[0,email.index(";")]
      end
      representative = Representative.new(name: name, party: party, district: district, img: img, profession: "NY State Senator", email:email, rating:"?", url: url)
      representative.save
      locations =  @doc.css(".adr")
      locations.each do |location|
        if location.children.length > 1
          office_name = location.css(".fn").text
          office_address = location.css(".street-address span").map {|address| address.text.strip}.join(" ")
          office_city = location.css(".locality").text.strip.delete_suffix(",")
          office_zipcode = location.css(".postal-code").text
          office_phone = location.css("[itemprop='telephone']").text.gsub(/\D/,"")
          if office_phone != ""
            office_phone = "("+office_phone[0,3]+") "+office_phone[3,3]+"-"+office_phone[6,4]
          end
          office_fax = location.css("[itemprop='faxNumber']").text.gsub(/\D/,"")
          if office_fax != ""
            office_fax = "("+office_fax[0,3]+") "+office_fax[3,3]+"-"+office_fax[6,4]
          end
          office = Office.new(name: office_name, address: office_address, city:office_city, zipcode: office_zipcode, phone: office_phone, fax: office_fax, representative_id: representative.id)
          office.save
        else
          next
        end
      end
    end
  end

  task state_assembly: :environment do
    @doc = Nokogiri::HTML(open("http://nyassembly.gov/mem/"))
    members = @doc.css(".mem-leader")
    members.each do |member|
      url = "http://nyassembly.gov#{member.css("strong a").attr("href")}"
      img = "http://nyassembly.gov#{member.css("img").attr("src")}"
      name = member.css("strong a").text
      district = member.css("strong").text.split("--")[1].strip
      email = member.css(".mem-email a").text
      representative = Representative.new(name: name,url: url, profession: "NY State Assembly Member", email: email, district: district, img: img,rating: "?",party: "(?)")
      representative.save
      locations = member.css(".full-addr")
      locations.each do |location|
        arr = location.text.split("  ")
        idx = arr.each_index.select{|i| arr[i].include? ", NY " }[0]
        if idx
          office_address = arr[0,idx].join("")
          office_city = arr[idx].split(", NY ")[0]
          office_zipcode = arr[idx].split(", NY ")[1]
          office_phone = arr[idx+1].gsub(/\D/,"")
          if office_phone != nil
            office_phone = "("+office_phone[0,3]+") "+office_phone[3,3]+"-"+office_phone[6,4]
          end
          office_fax = arr[idx+2]
          if office_fax != nil
            office_fax = office_fax.gsub(/\D/,"")
            office_fax = "("+office_fax[0,3]+") "+office_fax[3,3]+"-"+office_fax[6,4]
          end
          office_name = if office_address.include? "LOB"
            "Albany Office"
          else
            "District Office"
          end
          office = Office.new(name: office_name, address: office_address, city:office_city, zipcode: office_zipcode, phone: office_phone, fax: office_fax, representative_id: representative.id)
          office.save
        end
      end
    end
  end
end
