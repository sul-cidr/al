# author membership in categories for genre, form, lit. community, 
# social standing
class CreateAuthorCategories < ActiveRecord::Migration
  def change
    create_table :author_categories do |t|
    	t.integer :auth_id
    	t.integer :attribute_id
    	t.integer :category_id
     	t.timestamps null: false
    end

    # add_foreign_key :author_categories, :attributes
    # add_foreign_key :author_categories, :categories
  
  end
end
