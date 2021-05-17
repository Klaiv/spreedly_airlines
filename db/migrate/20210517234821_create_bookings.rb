class CreateBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :bookings do |t|
      t.integer :flight_id
      t.integer :amount
      t.string :payment_token
      t.boolean :save_credit_card
      t.boolean :pmd
      t.string :email

      t.timestamps
    end
  end
end
