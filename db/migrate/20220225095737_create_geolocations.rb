class CreateGeolocations < ActiveRecord::Migration[7.0]
  def change
    create_table :geolocations do |t|
      t.string :ip
      t.string :query
      t.string :country
      t.string :city
      t.string :zip
      t.string :latitude
      t.string :longitude

      t.timestamps
    end

    add_index :geolocations, :ip, unique: true
    add_index :geolocations, :query, unique: true
  end
end
