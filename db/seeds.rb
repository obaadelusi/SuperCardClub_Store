# Character.destroy_all
# Publisher.destroy_all
# Alignment.destroy_all
# Race.destroy_all
# AdminUser.destroy_all
# Province.destroy_all

# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

require 'uri'
require 'net/http'

# Get data from API
# url = URI("https://superhero-search.p.rapidapi.com/api/heroes")
url = URI("https://superhero-search.p.rapidapi.com/api/villains")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(url)
request["X-RapidAPI-Key"] = '94438023f0msh0b85bca741b4229p195ef8jsn1670d5c37c65'
request["X-RapidAPI-Host"] = 'superhero-search.p.rapidapi.com'

response = http.request(request)
data = JSON.parse(response.read_body) # Convert JSON data into Ruby data.

puts "Returned #{data.length()} super characters..."

race_unknown = Race.find_by(name: 'Unknown')

for c in data
  c_name = c["name"]
  c_fullname = c["biography"]["fullName"].strip.length==0 ? c_name : c["biography"]["fullName"]
  c_desc = "Fullname: #{c_fullname} \nGender: #{c["appearance"]["gender"]} \nAliases: #{(c["biography"]["aliases"]).join(", ")} \nAlter egos: #{c["biography"]["alterEgos"]} \nPoB: #{c["biography"]["placeOfBirth"]} \nGroup: #{c["connections"]["groupAffiliation"]} \nBase: #{c["work"]["base"]} \nOccupation: #{c["work"]["occupation"]} \nRelatives: #{c["connections"]["relatives"]}"
  c_price = Faker::Number.decimal(l_digits: 3, r_digits: 2)
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
  race = Race.find_or_create_by(name: c["appearance"]["race"])

  character = Character.find_by(name: c_name)

  if character.present?
    character.description = c_desc
    puts "--> #{character.name} aleady exists. Description updated."
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

    race.name.present? ? character.race = race : character.race = race_unknown

    character.image.attach(io: c_image, filename: "img-#{character.name.gsub(" ", "-")}.jpg")
    sleep(1)

    puts "# New: #{character.name} | on_sale: #{character.on_sale}"
  end

  character.save

end

# Add on_sale data to characters
# characters = Character.all

# for c in characters
  # ch = Character.find_by(name: "Robin")
  # ch_name = ch["name"]
  # url = URI("https://superhero-search.p.rapidapi.com/api/?hero=#{ch_name}")

  # http = Net::HTTP.new(url.host, url.port)
  # http.use_ssl = true

  # request = Net::HTTP::Get.new(url)
  # request["X-RapidAPI-Key"] = '94438023f0msh0b85bca741b4229p195ef8jsn1670d5c37c65'
  # request["X-RapidAPI-Host"] = 'superhero-search.p.rapidapi.com'

  # response = http.request(request)
  # d = JSON.parse(response.read_body) # Convert JSON data into Ruby data.
  # #pp d

  # c_fullname = d["biography"]["fullName"].strip.length==0 ? ch_name : d["biography"]["fullName"]
  # c_desc = "Fullname: #{c_fullname} \nGender: #{d["appearance"]["gender"]} \nAliases: #{(d["biography"]["aliases"]).join(", ")} \nAlter egos: #{d["biography"]["alterEgos"]} \nPoB: #{d["biography"]["placeOfBirth"]} \nFirst appearance: #{d["biography"]["firstAppearance"]} \nGroup: #{d["connections"]["groupAffiliation"]} \nBase: #{d["work"]["base"]} \nOccupation: #{d["work"]["occupation"]} \nRelatives: #{d["connections"]["relatives"]}"
  # ch.description = c_desc

  # ch_image = URI.open(d["images"]["md"])
  # ch.image.attach(io: ch_image, filename: "img-#{ch.name.gsub(" ", "-")}.jpg")
  # sleep(1)

  # rand = [0, 0, 0, 1, 0, 0, 1, 0, 0, 0]
  # ch.on_sale = rand.sample

  # puts "#{ch.name} card on_sale: #{ch.on_sale}"
  # ch.save
# end

## --->> Add provinces/territories

require 'nokogiri'
require 'open-uri'

def scrape_provinces
  url = 'https://en.wikipedia.org/wiki/Canadian_postal_abbreviations_for_provinces_and_territories'
  html = URI.open(url)
  doc = Nokogiri::HTML(html)

  provinces = []

  # The table containing the province names and abbreviations
  table = doc.at('table.wikitable')

  # Iterate over each row in the table, starting from the second row (skipping headers)
  table.css('tr')[1..].each do |row|
    th_cell = row.css('th')
    td_cells = row.css('td')

    # Extract province name and abbreviation from the cells
    name = th_cell[0].text.strip
    abbreviation = td_cells[0].text.strip

    # Add province to the provinces array
    provinces << { name: name, abbreviation: abbreviation }
  end

  provinces
end

provinces = scrape_provinces
provinces.each do |p|
  province = Province.find_or_create_by(name: p[:name], abbreviation: p[:abbreviation], country: 'Canada')
  puts "# Province: #{province.name} - #{province.abbreviation}"
end
