class ChangeDimensionToDim < ActiveRecord::Migration
  def change
    rename_column :categories, :dimension, :dim
  end
end
