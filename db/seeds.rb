# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'uri'
require 'net/http'

# Character.destroy_all
# Publisher.destroy_all
# Alignment.destroy_all
# Race.destroy_all
# AdminUser.destroy_all

# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

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

for c in data
  c_name = c["name"]
  c_fullname = c["biography"]["fullName"].strip.length==0 ? c_name : c["biography"]["fullName"]
  c_desc = "Fullname: #{c_fullname} \nGender: #{c["appearance"]["gender"]} \nAliases: #{(c["biography"]["aliases"]).join(", ")} \nAlter egos: #{c["biography"]["alterEgos"]} \nPoB: #{c["biography"]["placeOfBirth"]} \nGroup: #{c["connections"]["groupAffiliation"]} \nBase: #{c["work"]["base"]} \nOccupation: #{c["work"]["occupation"]}"
  c_price = Faker::Number.decimal(l_digits: 3, r_digits: 2)
  c_combat = c["powerstats"]["combat"]
  c_durability = c["powerstats"]["durability"]
  c_intel = c["powerstats"]["intelligence"]
  c_power = c["powerstats"]["power"]
  c_speed = c["powerstats"]["speed"]
  c_strength = c["powerstats"]["strength"]
  c_image = URI.open(c["images"]["md"])
  rand = [0, 0, 0, 1, 0, 0, 1, 0, 0, 0]


  publisher = Publisher.find_or_create_by!(name: c["biography"]["publisher"])
  race = Race.find_or_create_by!(name: c["appearance"]["race"])
  alignment = Alignment.find_or_create_by!(name: c["biography"]["alignment"])

  character = Character.find_or_create_by(name: c_name)
  character.description = c_desc
  character.price = c_price
  character.onSale = rand.sample
  character.stat_combat = c_combat
  character.stat_durability = c_durability
  character.stat_intelligence = c_intel
  character.stat_power = c_power
  character.stat_speed = c_speed
  character.stat_strength = c_strength
  character.publisher = publisher
  character.race = race
  character.alignment = alignment
  character.image.attach(io: c_image, filename: "img-#{character.name.gsub(" ", "-")}.jpg")
  sleep(1)

  character.save

  puts "Added: #{character.name} | onSale: #{character.onSale}"
end

# Add onSale data to characters
# characters = Character.all

# for c in characters
  # c_name = c["name"]
  # url = URI("https://superhero-search.p.rapidapi.com/api/?hero=#{c_name}")

  # http = Net::HTTP.new(url.host, url.port)
  # http.use_ssl = true

  # request = Net::HTTP::Get.new(url)
  # request["X-RapidAPI-Key"] = '94438023f0msh0b85bca741b4229p195ef8jsn1670d5c37c65'
  # request["X-RapidAPI-Host"] = 'superhero-search.p.rapidapi.com'

  # response = http.request(request)
  # d = JSON.parse(response.read_body) # Convert JSON data into Ruby data.
  # pp d

  # c_fullname = d["biography"]["fullName"].strip.length==0 ? c_name : d["biography"]["fullName"]
  # c_desc = "Fullname: #{c_fullname} \nGender: #{d["appearance"]["gender"]} \nAliases: #{(d["biography"]["aliases"]).join(", ")} \nAlter egos: #{d["biography"]["alterEgos"]} \nPoB: #{d["biography"]["placeOfBirth"]} \nFirst appearance: #{d["biography"]["firstAppearance"]} \nGroup: #{d["connections"]["groupAffiliation"]} \nBase: #{d["work"]["base"]} \nOccupation: #{d["work"]["occupation"]} \nRelatives: #{d["connections"]["relatives"]}"
  # c.description = c_desc

  # rand = [0, 0, 0, 1, 0, 0, 1, 0, 0, 0]
  # c.onSale = rand.sample

  # puts "#{c.name} card onSale: #{c.onSale}"
  # c.save
# end
