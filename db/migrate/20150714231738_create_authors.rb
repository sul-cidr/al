class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
    	t.integer :auth_id
    	t.string :prefname #label
    	t.string :surname
    	t.string :middle
    	t.string :given
    	t.date :birth_date
    	t.date :death_date
    	t.integer :birth_year
    	t.integer :death_year
    	t.integer :viaf_id
    	t.string :wiki_id
    	
		t.timestamps null: false
    end
  end
end
