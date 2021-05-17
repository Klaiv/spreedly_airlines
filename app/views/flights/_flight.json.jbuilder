json.extract! flight, :id, :origin_airport, :destination_airport, :departure_date, :cost, :created_at, :updated_at
json.url flight_url(flight, format: :json)
