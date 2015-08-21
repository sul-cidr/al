class CreateAuthorStandings < ActiveRecord::Migration
  def change
    create_table :author_standings do |t|

    	t.integer :author_id
    	t.integer :standing_id

      t.timestamps null: false
    end

    add_index :author_standings, ["author_id","standing_id"]
  end

  def down
  	drop_table :author_standings
  end
end
