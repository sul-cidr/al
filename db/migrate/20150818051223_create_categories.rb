class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.integer :category_id
    	t.string :name
      t.string :dim
      t.timestamps null: false
    end
  end
end
