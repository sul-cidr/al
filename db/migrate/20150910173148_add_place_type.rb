class AddPlaceType < ActiveRecord::Migration
  def change
    add_column :places, :place_type, :string 
  end
end
