# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Flight.delete_all

puts 'Creating Flights'

#Hard Code a few flights


Flight.create!(origin_airport: 'San Francisco (SFO)',
                 destination_airport: 'Portland (PDX)',
                 departure_date: rand(4..17).days.from_now.strftime('%Y-%m-%d'),
                 cost: '312')

Flight.create!(origin_airport: 'Raleigh-Durham (RDU)',
                 destination_airport: 'Harare (HRE)',
                 departure_date: rand(4..17).days.from_now.strftime('%Y-%m-%d'),
                 cost: '1420')


Flight.create!(origin_airport: 'Raleigh-Durham (RDU)',
                 destination_airport: 'Portland PDX',
                 departure_date: rand(4..17).days.from_now.strftime('%Y-%m-%d'),
                 cost: '620')
Flight.create!(origin_airport: 'Raleigh-Durham (RDU)',
                 destination_airport: 'New York (JFK)',
                 departure_date: rand(4..17).days.from_now.strftime('%Y-%m-%d'),
                 cost: '230')