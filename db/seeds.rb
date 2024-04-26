# Character.destroy_all
# Publisher.destroy_all
# Alignment.destroy_all
# Race.destroy_all
AdminUser.destroy_all
# # Province.destroy_all

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

require 'uri'
require 'net/http'

alignments = ["heroes", "villains"]

alignments.each do |alignment|
# Get data from API
url = URI("https://superhero-search.p.rapidapi.com/api/#{alignment}")
puts ">>> Getting #{alignment} from API..."

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(url)
request["X-RapidAPI-Key"] = '94438023f0msh0b85bca741b4229p195ef8jsn1670d5c37c65'
request["X-RapidAPI-Host"] = 'superhero-search.p.rapidapi.com'

response = http.request(request)
data = JSON.parse(response.read_body) # Convert JSON data into Ruby data.

puts "Returned #{data.length()} super #{alignment}..."

race_unknown = Race.find_by(name: "Unknown")

for c in data
  c_name = c["name"]
  c_fullname = c["biography"]["fullName"].strip.length==0 ? c_name : c["biography"]["fullName"]
  c_desc = "Fullname: #{c_fullname} \nGender: #{c["appearance"]["gender"]} \nAliases: #{(c["biography"]["aliases"]).join(", ")} \nAlter egos: #{c["biography"]["alterEgos"]} \nPoB: #{c["biography"]["placeOfBirth"]} \nGroup: #{c["connections"]["groupAffiliation"]} \nBase: #{c["work"]["base"]} \nOccupation: #{c["work"]["occupation"]} \nRelatives: #{c["connections"]["relatives"]}"
  c_price = Faker::Number.decimal(l_digits: 2, r_digits: 2)
  c_combat = c["powerstats"]["combat"]
  c_durability = c["powerstats"]["durability"]
  c_intel = c["powerstats"]["intelligence"]
  c_power = c["powerstats"]["power"]
  c_speed = c["powerstats"]["speed"]
  c_strength = c["powerstats"]["strength"]
  c_image = URI.open(c["images"]["md"])
  rand = [0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0]

  publisher = Publisher.find_or_create_by!(name: c["biography"]["publisher"])
  alignment = Alignment.find_or_create_by!(name: c["biography"]["alignment"])
  race = Race.find_or_create_by!(name: c["appearance"]["race"])

  character = Character.find_by(name: c_name)

  if character.present?
    character.description = c_desc
    puts "--> #{character.name} aleady exists | race: #{character.race.id}"
  else
    character = Character.create(name: c_name)
    character.description = c_desc
    character.price = c_price
    character.on_sale = rand.sample
    character.stat_combat = c_combat
    character.stat_durability = c_durability
    character.stat_intelligence = c_intel
    character.stat_power = c_power
    character.stat_speed = c_speed
    character.stat_strength = c_strength
    character.publisher = publisher
    character.alignment = alignment

    race.name.nil? ? character.race = race_unknown : character.race = race

    c_image_filename = "img-#{character.name.gsub(" ", "-")}.jpg"
    character.image.attach(io: c_image, filename: c_image_filename, content_type: "image/jpeg")
    sleep(1)
  end

  character.save
  puts "## New product: #{character.name} | price: $#{character.price}"
  if race.name.nil?
    race.destroy
  end

end

end


## --->> Add provinces/territories
require 'nokogiri'
require 'open-uri'

def scrape_provinces
  puts "# Scraping provinces from web..."
  provinces = []

  url = "https://www.avalara.com/vatlive/en/country-guides/north-america/canada/canadian-vat-compliance-and-rates.html"
  doc = Nokogiri::HTML(URI.open(url))

  table = doc.at('table')

  table.css('tr').each do |row|
    td_cells = row.css('td')

    nameCell = td_cells[0]
    typeCell = td_cells[1]
    pstCell = td_cells[3]
    gstCell = td_cells[4]

    if !gstCell.nil? && !gstCell.text.nil? && gstCell.text.strip != "Federal GST"
      nameStr = nameCell.text.strip
      typeStr = typeCell.text.strip
      pstStr = pstCell.text.strip.gsub("%", "")
      gstStr = gstCell.text.strip.gsub("%", "")

      pst = typeStr.downcase.include?("pst") ||
        typeStr.downcase.include?("qst") ? (pstStr.to_f/100).round(5) : nil
      gst = (gstStr.to_f/100).round(2)
      hst = typeStr.downcase.include?("hst") ?
        pstStr.to_f/100 : nil

      provinces << {
      name: nameStr,
      pst: pst,
      gst: gst,
      hst: hst,
    }
  end
  end
  provinces
end

provinces = scrape_provinces
provinces.each do |p|
  prov = Province.find_or_create_by(name: p[:name], gst: p[:gst], pst: p[:pst], hst: p[:hst], country: "Canada")
  puts "#{prov.name} \tGST: #{prov.gst} | PST: #{prov.pst} | HST: #{prov.hst}"
end
