json.array! @areas do |area|
  json.extract!(
    area,
    :id,
    :area_type,
    :name,
    :geom_wkt
  )
end
