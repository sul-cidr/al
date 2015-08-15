class Passage < ActiveRecord::Base

	def to_param
  	passage_id
	end

	belongs_to :works

end
