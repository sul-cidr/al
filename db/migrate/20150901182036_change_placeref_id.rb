class ChangePlacerefId < ActiveRecord::Migration
  def change
  	change_column :placerefs, :placeref_id, 
  	'integer USING CAST(placeref_id AS integer)'
  end
end
