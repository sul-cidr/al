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

  def self.active
    find_by_sql(
      "SELECT distinct on(ar.id) ar.*
      FROM areas ar, placerefs pr
      WHERE ST_Intersects(st_geomfromtext(ar.geom_poly_wkt), st_geomfromtext(pr.geom_wkt))
      AND pr.author_id > -1
      AND pr.geom_wkt not like '%POLYGON%'
      GROUP BY ar.id
      ORDER BY ar.id;
      "
    )
  end
    # where {
    #   SELECT distinct on(ar.id) ar.*
    #   FROM areas ar, placerefs pr
    #   WHERE ST_Intersects(st_geomfromtext(ar.geom_poly_wkt), st_geomfromtext(pr.geom_wkt))
    #   GROUP BY ar.id
    #   ORDER BY ar.id;
    #   # SELECT distinct on(ar.id) ar.*
    #   # FROM areas ar, placerefs pr
    #   # WHERE ST_Intersects(st_geomfromtext(ar.geom_poly_wkt), st_geomfromtext(pr.geom_wkt))
    #   # GROUP BY ar.id
    #   # ORDER BY ar.id;
    # }

  def self.in_or_near(id)
    where {
        geom_wkt like 'MULTIPOINT%' and
      	st_intersects(
          st_buffer( (st_geomfromtext(Area.find(id).geom_wkt)), 0.01),
      	  st_geomfromtext(geom_wkt)
        )
      # st_geomfromtext(Area.find(id).geom_wkt)
    }
  end

end
