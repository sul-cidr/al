# == Schema Information
#
# Table name: areas
#
#  id             :integer          not null, primary key
#  prefname       :string
#  area_type      :string
#  geom_poly_wkt  :text
#  geom_point_wkt :text
#  parent_id      :integer
#  geom_poly      :geometry({:srid= polygon, 4326
#  geom_point     :geometry({:srid= point, 4326
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Area < ActiveRecord::Base

  self.primary_key = 'area_id'

  # borough or hood
  def self.of_type(t)
    where {
      area_type == t
    }
  end


  def self.active
    find_by_sql(
      "SELECT distinct on(ar.area_id) ar.*
      FROM areas ar, placerefs pr
      WHERE ST_Intersects(st_geomfromtext(ar.geom_poly_wkt), st_geomfromtext(pr.geom_wkt))
      AND pr.author_id > -1
      AND pr.geom_wkt not like '%POLYGON%'
      GROUP BY ar.area_id
      ORDER BY ar.area_id;
      "
    )
  end

  def self.in_or_near(id)
    where {
        geom_wkt like 'POINT%' and
        st_intersects(
          st_buffer( (st_geomfromtext(Area.find(id).geom_point_wkt)), 0.01),
          st_geomfromtext(geom_point_wkt)
        )
    }
  end

end
