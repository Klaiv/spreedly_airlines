
class Booking < ApplicationRecord
	belongs_to :flight
	validates_presence_of :email
	validates_presence_of :payment_token
	validates_presence_of :amount

end
