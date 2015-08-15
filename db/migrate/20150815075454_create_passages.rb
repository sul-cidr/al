class CreatePassages < ActiveRecord::Migration
  def up
    create_table :passages do |t|
    	t.string :passage_id # work.{int}
    	t.string :work_id
    	t.text :text
    	t.string :placerefs # place references in this passage
     	t.timestamps null: false
    end

  add_foreign_key :passages, :works

  end

  def down
    drop_table passages
  end

end
