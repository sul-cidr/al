class Dimension < ActiveRecord::Base

	has_many :categories
	has_and_belongs_to_many :authors, :join_table => "authors_dimensions"

end
