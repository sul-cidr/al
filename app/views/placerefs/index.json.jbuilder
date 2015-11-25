json.array! @placerefs do |place|
  json.extract!(
    place,
    :placeref_id,
    :placeref_type,
    :placeref,
    :author_id,
    :work_id,
    :place_id,
    :geom_wkt
  )
end
