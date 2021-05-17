json.extract! booking, :id, :flight_id, :amount, :payment_token, :save_credit_card, :pmd, :email, :created_at, :updated_at
json.url booking_url(booking, format: :json)
