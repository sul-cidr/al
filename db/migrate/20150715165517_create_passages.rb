class CreatePassages < ActiveRecord::Migration
  def change
    create_table :passages do |t|
    	t.string :passage_id # work.{int}
    	t.string :work_id
    	t.text :text
    	t.string :placerefs # place references in this passage
     	t.timestamps null: false
    end

  add_foreign_key :passages, :works

  end
end
