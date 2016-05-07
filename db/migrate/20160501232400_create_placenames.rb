class CreatePlacenames < ActiveRecord::Migration
  def up
    create_table :placenames do |t|
      t.string :placename_id
      t.string :placename
      t.timestamps null: false
    end
  end

  def down
    drop_table :placenames
  end
end
