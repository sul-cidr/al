json.array! @authors do |author|
  json.extract!(
    author,
    :author_id,
    :prefname
  )
end