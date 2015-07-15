class CreatePlacerefs < ActiveRecord::Migration
  def change
    create_table :placerefs do |t|

      t.timestamps null: false
    end
  end
end
