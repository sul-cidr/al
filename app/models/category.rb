# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ActiveRecord::Base

	belongs_to :dimension
	has_and_belongs_to_many :authors, :through => :authors_categories

end
