# == Schema Information
#
# Table name: places
#
#  id         :integer          not null
#  place_id   :integer          primary key
#  source     :string
#  geom_wkt   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  latitude   :float
#  longitude  :float
#  names      :string
#  place_type :string
#

class Place < ActiveRecord::Base
  self.primary_key = 'place_id'

  has_many :placerefs
  has_many :passages, :through => :placerefs
  has_many :works, :through => :passages
  has_many :authors, :through => :works


end
