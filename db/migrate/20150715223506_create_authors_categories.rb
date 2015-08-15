# author membership in categories for genre, form, lit. community, 
# social standing
class CreateAuthorsCategories < ActiveRecord::Migration
  def up
    create_table :authors_categories, :id => false do |t|
    	t.integer :author_id
      t.integer :category_id
    	t.integer :attribute_id
    end

    add_index :authors_categories, [:author_id, :category_id ]

  end

  def down
    drop_table :authors_categories
  end
end
