json.array! @areas do |area|
  json.extract!(
    area,
    :id,
    :area_type,
    :parent_id,
    :name,
    :geom_wkt
  )
end
