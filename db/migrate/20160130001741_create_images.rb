class CreateImages < ActiveRecord::Migration
  def change
    create_table :images, {:id => false} do |t|

      t.integer :image_id
      t.string :filename
      t.string :label
      t.text :caption
      t.text :geom_wkt
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end

    execute "ALTER TABLE images ADD PRIMARY KEY (image_id);"

  end
end
