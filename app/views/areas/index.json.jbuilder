json.array! @areas do |area|
  json.extract!(
    area,
    :id,
    :prefname,
    :area_type,
    :parent_id,
    :geom_point_wkt,
    :geom_poly_wkt
  )
end
