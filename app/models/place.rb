# == Schema Information
#
# Table name: places
#
#  place_id        :integer          primary key
#  place_type      :string
#  prefname        :string
#  latitude        :float
#  longitude       :float
#  geom_wkt        :text
#  geom_wkt_l      :text
#  geom_wkt_a      :text
#  source          :string
#  placerefs_count :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Place < ActiveRecord::Base
  self.primary_key = 'place_id'

  has_many :placerefs
  has_many :passages, :through => :placerefs
  has_many :works, :through => :passages
  has_many :authors, :through => :works


end
