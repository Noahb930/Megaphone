namespace :scrape do
  require 'nokogiri'
  require 'open-uri'
  task ny_senate: :environment do
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
          office = Office.new(name: office_name, address: office_address, city:office_city, state:"NY", zipcode: office_zipcode, phone: office_phone, fax: office_fax, representative_id: representative.id)
          office.save
        end
      end
    end
  end

  task ny_assembly: :environment do
    @doc = Nokogiri::HTML(URI("http://nyassembly.gov/mem/").open)
    members = @doc.css(".mem-leader")
    members.each do |member|
      url = "http://nyassembly.gov#{member.css("strong a").attr("href")}"
      img = "http://nyassembly.gov#{member.css("img").attr("src")}"
      name = member.css("strong a").text
      if name.include? "Assembly District"
        name = "Vacant Seat"
      end
      district = member.css("strong").text.split("--")[1].strip
      email = member.css(".mem-email a").text.strip
      representative = Representative.new(name: name,url: url, profession: "NY State Assembly Member", email: email, district: district, img: img,rating: "?",party: "(?)")
      representative.save!
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
            if office_fax.length < 10
              office_fax = office_phone[1,3]+office_fax
            end
            office_fax = "("+office_fax[0,3]+") "+office_fax[3,3]+"-"+office_fax[6,4]
          end
          office_name = if office_address.include? "LOB"
            "Albany Office"
          else
            "District Office"
          end
          office = Office.new(name: office_name, address: office_address, city:office_city, state:"NY", zipcode: office_zipcode, phone: office_phone, fax: office_fax, representative_id: representative.id)
          office.save!
        end
      end
    end
  end

  task nyc_council: :environment do
    @doc = Nokogiri::HTML(URI("https://council.nyc.gov/districts").open)
    members = @doc.css(".list tr")
    members.each do |member|
      district = "District "+member.css(".sort-district strong").text
      name = "District "+member.css(".sort-member strong").text
      url = member.css(".sort-member a").attr("href")
      img = member.css("img").attr("src")
      party = member.css(".sort-party").text[0]
      if party != nil
        party = "("+party+")"
      end
      email = member.css(".sort-email a")[0]
      if email
        email = email.attr("href").sub("mailto:","")
      end
      @doc = Nokogiri::HTML(URI(url).open)
      offices = @doc.css("[aria-label~='office']")
      representative = Representative.new(name: name, party: party, email:email, district: district, img: img, profession: "NYC City Council Member", rating:"?", url: url)
      representative.save!
      offices.each do |office|
        office_name = office.css("h2").text
        office_address= office.css(".text-small").text.split("\n")[0]
        office_city= office.css(".text-small").text.split("\n")[1].split(",")[0]
        office_zipcode= office.css(".text-small").text.scan(/(?<=NY )\d{5}/)[0]
        office_phone= office.css(".text-small").text.scan(/\d{3}-\d{3}-\d{4}(?= phone)/)[0]
        if office_phone != nil
          office_phone = office_phone.gsub(/\D/,"")
          office_phone = "("+office_phone[0,3]+") "+office_phone[3,3]+"-"+office_phone[6,4]
        end
        office_fax= office.css(".text-small").text.scan(/\d{3}-\d{3}-\d{4}(?= fax)/)[0]
        if office_fax != nil
          office_fax = office_fax.gsub(/\D/,"")
          office_fax = "("+office_fax[0,3]+") "+office_fax[3,3]+"-"+office_fax[6,4]
        end
        office = Office.new(name: office_name, address: office_address, city:office_city, state:"NY", zipcode: office_zipcode, phone: office_phone, representative_id: representative.id)
        office.save!
      end
    end
  end
  task us_house: :environment do
    @doc = Nokogiri::HTML(URI("https://www.house.gov/representatives").open)
    members = @doc.css("#state-new-york ~ tbody").css("tr")
    members.each do |member|
      district = "District "+member.css("td")[0].text.scan(/\d+/)[0]
      url = member.css("a").attr("href")
      name = member.css("a").text
      name = name.split(", ")[1] +" " +name.split(", ")[0]
      party = "("+member.css("td")[2].text.strip+")"
      representative = Representative.new(name: name, party: party, district: district, img: "?", profession: "US House Member", rating:"?", url: url)
      representative.save!
      office_address = member.css("td")[3].text + " Senate Office Building\nUnited States Senate"
      office_address.sub!("CHOB","Cannon House Office Building")
      office_address.sub!("LHOB","Longworth House Office Building")
      office_address.sub!("RHOB","Rayburn House Office Building")
      office_phone = member.css("td")[4].text
      office = Office.new(name: "D.C Office", address: office_address, city:"Washington", state:"D.C.", zipcode: "20510", phone: office_phone, representative_id: representative.id)
      office.save!
    end
  end
  task us_senate: :environment do
    @doc = Nokogiri::HTML(URI("https://www.congress.gov/members?q={%22congress%22:%22116%22,%22chamber%22:%22Senate%22,%22member-state%22:%22New+York%22}&searchResultViewType=expanded&KWICView=false").open)
    senators = @doc.css(".expanded")
    senators.each do |senator|
      url = senator.css("a").attr("href")
      name = senator.css("a").text.sub("Senator ","")
      name = name.split(", ")[1] + name.split(", ")[0]
      party = "("+senator.css(".result-item")[1].css("span")[0].text[0]+")"
      img = "https://www.congress.gov" + senator.css("img").attr("src")
      representative = Representative.new(name: name, party: party,img: img, profession: "US Senator", rating:"?", url: url)
      representative.save!
      @doc = Nokogiri::HTML(URI(url).open)
      office_address = @doc.css(".member_contact + td").text.split(" Washington")[0]
      office_phone = @doc.css(".member_contact + td").text.split("\n")[1]
      office = Office.new(name: "D.C Office", address: office_address, city:"Washington", state:"D.C.", zipcode: "20510", phone: office_phone, representative_id: representative.id)
      office.save!
    end
  end
end
