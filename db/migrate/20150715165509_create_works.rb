class CreateWorks < ActiveRecord::Migration
  def up
    create_table :works, {:id => false} do |t|
    	t.integer :work_id
    	t.string :title
    	t.integer :author_id
    	t.integer :pub_year
    	t.integer :subject_id # subject of bio essay
     	t.timestamps null: false
    end

    # add_foreign_key :works, :authors

    execute "ALTER TABLE works ADD PRIMARY KEY (work_id);"
    
  end

  def down
    drop_table :works
  end
end
