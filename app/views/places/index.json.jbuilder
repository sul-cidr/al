json.array! @places do |place|
  json.extract!(
    place,
    :place_id,
    :place_type,
    :names,
    :geom_wkt
  )
end