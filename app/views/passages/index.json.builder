json.array! @passages do |passage|
  json.extract!(
    passage,
    :passage_id,
    :work_id,
    :subject_id,
    :subject_label,
    :text
  )
end