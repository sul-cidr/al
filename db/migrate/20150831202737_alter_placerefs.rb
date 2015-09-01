class AlterPlacerefs < ActiveRecord::Migration
  def change
  	add_column :placerefs, :work_id, :integer
  end
end
