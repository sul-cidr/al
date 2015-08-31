# reference in a work passage to a place

class Placeref < ActiveRecord::Base
	self.primary_key = 'placeref_id'


	belongs_to :passage
	has_one :place

end
