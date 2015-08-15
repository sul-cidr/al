class Work < ActiveRecord::Base

	belongs_to :authors
	has_many :passages

end
