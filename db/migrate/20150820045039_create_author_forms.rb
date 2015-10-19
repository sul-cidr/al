class CreateAuthorForms < ActiveRecord::Migration
  def up
    create_table :author_forms do |t|

    	t.integer :author_id
    	t.integer :form_id

      t.timestamps null: false
    end

    add_index :author_forms, ["author_id","form_id"]
  end

  def down
  	drop_table :author_forms
  end
end
