class CreateAuthorCommunities < ActiveRecord::Migration
  def change
    create_table :author_communities do |t|

    	t.integer :author_id
    	t.integer :community_id

      t.timestamps null: false
    end

    add_index :author_communities, ["author_id","community_id"]
  end

  def down
  	drop_table :author_communities
  end

end
