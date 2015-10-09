# areas are boroughs, neighborhoods, (poss.) wards for navigating spatially

class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name
      t.string :area_type
      t.integer :parent_id
      t.string :altnames
      t.text :geom_wkt
      t.point :geom_point, srid:4326
      t.multi_polygon :geom_mpoly, srid:4326

      t.timestamps null: false
    end
  end
end
