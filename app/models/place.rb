class Place < ActiveRecord::Base
	self.primary_key = 'place_id'

	has_and_belongs_to_many :placerefs

end
