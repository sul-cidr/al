json.array! @works do |work|
  json.extract!(
    work,
    :work_id,
    :author_id,
    :title,
    :work_year,
    :categories,
    :keywords
  )
end
