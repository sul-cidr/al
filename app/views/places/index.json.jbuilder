json.array! @places do |place|
  json.extract!(
    place,
    :place_id,
    :names
  )
end