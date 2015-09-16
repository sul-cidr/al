json.array! @works do |work|
  json.extract!(
    work,
    :work_id,
    :author_id,
    :subject_id,
    :subject_label,
    :title,
    :pub_year
  )
end
