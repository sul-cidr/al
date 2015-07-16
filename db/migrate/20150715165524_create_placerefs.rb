# placeref = reference in text to a place
# fk place_id --> place.place_id
class CreatePlacerefs < ActiveRecord::Migration
  def change
    create_table :placerefs do |t|
    	t.integer :placeref_id
    	t.string :prefname # may be altered from original
    	t.integer :place_id
    	t.string :passage_id # was placerefs.source_loc
     	t.timestamps null: false
    end
  end
end
