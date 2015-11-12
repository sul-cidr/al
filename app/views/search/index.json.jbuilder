json.array! @passages.hits do |hit|
  json.results hit.result
end
