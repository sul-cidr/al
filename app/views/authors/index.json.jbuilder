json.array! @authors do |author|
  json.extract!(
    author,
    :author_id,
    :prefname,
    :surname,
    :viaf_id,
    :wiki_id,
    :birth_year,
    :death_year,
    :categories
  )
end
