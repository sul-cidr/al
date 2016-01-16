class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories, {:id => false} do |t|
      t.integer :category_id
    	t.string :name
      t.integer :dimension_id
      
      t.timestamps null: false
    end

    execute "ALTER TABLE categories ADD PRIMARY KEY (category_id);"
  end
end
