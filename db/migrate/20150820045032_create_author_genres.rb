class CreateAuthorGenres < ActiveRecord::Migration
  def up
    create_table :author_genres do |t|

    	t.integer :author_id
    	t.integer :genre_id

      t.timestamps null: false
    end

    add_index :author_genres, ["author_id","genre_id"]
  end

  def down
  	drop_table :author_genres
  end

end
