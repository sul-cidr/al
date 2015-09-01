class AlterPlaces < ActiveRecord::Migration
  def up
  	remove_column :places, :geom_mpoint 
  	remove_column :places, :geom_line 
  	remove_column :places, :geom_mpoly
  	rename_column :places, :src, :source
  	add_column :places, :latitude, :float
  	add_column :places, :longitude, :float
  	add_column :places, :names, :string
  end

  def down
  	add_column :places, :geom_mpoint 
  	add_column :places, :geom_line 
  	add_column :places, :geom_mpoly
  	rename_column :places, :source, :src
  	remove_column :places, :latitude
  	remove_column :places, :longitude
  	remove_column :places, :names
  end

end
