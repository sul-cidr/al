json.array! @categories do |category|
  json.extract!(
    category,
    :id,
    :name,
    :dim
  )
end