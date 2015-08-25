class CreatePassages < ActiveRecord::Migration
  def up
    create_table :passages, {:id => false}  do |t|
    	t.string :passage_id 
    	t.integer :work_id
    	t.text :text
    	t.string :placerefs # place references in this passage
     	t.timestamps null: false
    end

  # add_foreign_key :passages, :works
  # add_foreign_key :passages, column: :passage_id, primary_key: "passage_id"
  # add_foreign_key :works, column: :work_id, primary_key: "work_id"

  execute "ALTER TABLE passages ADD PRIMARY KEY (passage_id);"

  end

  def down
    drop_table :passages
  end

end
