json.array! @works do |work|
  json.extract!(
    work,
    :work_id,
    :author_id,
    :subject_id,
    :title,
    :pub_year
  )
end
