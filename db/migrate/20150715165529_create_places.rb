# a Place has a geometry, for 1..* placerefs
class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
    	
    	t.integer :place_id
    	t.string :src # where geometry came from, e.g. google geocode (gcode)
    	t.text :geom_wkt
    	t.multi_point :geom_mpoint, srid:4326
    	t.multi_polygon :geom_mpoly, srid:4326
    	t.line_string :geom_line, srid:4326

     	t.timestamps null: false
    end
  end
end
