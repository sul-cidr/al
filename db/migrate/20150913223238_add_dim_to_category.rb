class AddDimToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :dimension, :string
  end
end
