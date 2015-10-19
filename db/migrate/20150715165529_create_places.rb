# a Place has a geometry, for 1..* placerefs
class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
    	t.integer :place_id
      t.string :place_type
      t.string :names
      t.string :source
      t.float :latitude
      t.float :longitude
    	t.text :geom_wkt
     	t.timestamps null: false
    end
  end
end
