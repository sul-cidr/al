class Category < ActiveRecord::Base

	belongs_to :dimension
	has_and_belongs_to_many :authors, :through => :authors_categories

end
