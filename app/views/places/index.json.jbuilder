json.array! @places do |place|
  json.extract!(
    place,
    :place_id,
    :prefname,
    :geom_wkt
  )
end
