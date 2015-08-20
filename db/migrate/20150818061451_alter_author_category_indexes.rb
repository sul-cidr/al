class AlterAuthorCategoryIndexes < ActiveRecord::Migration
  def change
  	remove_index(:authors_categories, 
  		:name => 'index_authors_categories_on_author_id_and_category_id')
  	add_index :authors_categories, ["author_id","dimension_id"]
  end
end
