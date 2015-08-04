class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
    	t.integer :work_id
    	t.string :title
    	t.integer :auth_id
    	t.integer :pub_year
    	t.integer :subject_id # subject of bio essay
     	t.timestamps null: false
    end

    add_foreign_key :works, :authors
    
  end

end
