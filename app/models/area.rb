# == Schema Information
#
# Table name: areas
#
#  id         :integer          not null, primary key
#  name       :string
#  area_type  :string
#  altnames   :string
#  geom_wkt   :text
#  geom_point :point            point, 0
#  geom_mpoly :geometry({:srid= multipolygon, 4326
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Area < ActiveRecord::Base

  # borough or hood
  def self.of_type(t)
    where {
      area_type == t
    }
  end

  # hoods in borough
  def self.child_of(id)
    where {
      (area_type == "hood") &
      st_intersects( st_geomfromtext(geom_wkt), st_geomfromtext(Area.find(id).geom_wkt) )
    }
  end

end
