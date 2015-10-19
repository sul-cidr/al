class AddCatArrayToAuthors < ActiveRecord::Migration
  def change
    add_column :authors, :categories, :integer, array: true, default: []
  end

end
