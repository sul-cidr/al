json.array! @places do |place|
  json.extract!(
    place,
    :place_id,
    :prefname,
    :geom_wkt,
    :placerefs_count,
    :auth_array
  )
end
