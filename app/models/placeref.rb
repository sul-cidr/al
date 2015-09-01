# == Schema Information
#
# Table name: placerefs
#
#  id          :integer          not null
#  placeref_id :integer          primary key
#  prefname    :string
#  place_id    :integer
#  passage_id  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  work_id     :integer
#

# reference in a work.passage to a place

class Placeref < ActiveRecord::Base
	self.primary_key = 'placeref_id'

	belongs_to :passage
	has_one :place

end
