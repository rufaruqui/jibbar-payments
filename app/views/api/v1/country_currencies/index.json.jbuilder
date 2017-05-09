json.Countries @countries do |country|
  json.name country.country
  json.currency country.currency
end
json.success true
json.errors nil

