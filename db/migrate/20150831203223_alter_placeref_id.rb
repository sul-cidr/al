class AlterPlacerefId < ActiveRecord::Migration
  def change
  	change_column :placerefs, :placeref_id, :string
  end
end
