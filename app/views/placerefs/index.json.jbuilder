json.array! @places do |place|
  json.extract!(
    place,
    :placeref_id,
    :placeref_type,
    :prefname,
    :author_id,
    :work_id,
    :place_id,
    :geom_wkt
  )
end
