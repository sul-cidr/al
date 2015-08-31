class Passage < ActiveRecord::Base

	def to_param
  	passage_id
	end

	belongs_to :work, foreign_key: :work_id
	has_many :placerefs, foreign_key: :passage_id

end