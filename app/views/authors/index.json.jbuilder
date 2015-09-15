json.array! @authors do |author|
  json.extract!(
    author,
    :author_id,
    :prefname,
    :surname,
    :viaf_id,
    :death_year
  )
end