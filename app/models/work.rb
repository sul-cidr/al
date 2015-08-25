class Work < ActiveRecord::Base

	self.primary_key = 'work_id'

	belongs_to :author, foreign_key: :author_id
	# has_many :passages

end
