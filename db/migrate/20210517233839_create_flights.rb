class CreateFlights < ActiveRecord::Migration[6.0]
  def change
    create_table :flights do |t|
      t.string :origin_airport
      t.string :destination_airport
      t.date :departure_date
      t.integer :cost

      t.timestamps
    end
  end
end
