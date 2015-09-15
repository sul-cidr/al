json.array! @works do |work|
  json.extract!(
    work,
    :work_id,
    :auth_id,
    :subject_id,
    :title,
    :pub_year,
    :type
  )
end