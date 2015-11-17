# works but results nested in 'results'
json.array! @passages.hits do |hit|
  hit.highlights(:text).each do |highlight|
    puts "  " + highlight.format { |word| "<b>#{word}</b>" }
    json.text hit.result.text
  end
  json.passage_id hit.result.passage_id
  json.work_id hit.result.work_id
  # json.text hit.result.text
end

# @passages.hits.each do |hit|
#   puts "Post ##{hit.primary_key}"
#
#   hit.highlights(:text).each do |highlight|
#     puts "  " + highlight.format { |word| "<b>#{word}</b>" }
#   end
# end
