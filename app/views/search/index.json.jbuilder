# works but results nested in 'results'
json.array! @passages.hits do |hit|
  json.passage_id hit.result.passage_id
  json.work_id hit.result.work_id
  json.text hit.result.text
end

# json.array! @passages.hits do |hit|
#   json.results hit.result
# end

# json.array!(@passages.hits) do |hit|
#   json.results do
#     json.array!(hit.result) do |r|
#       json.passage_id r.passage_id
#       json.work_id r.work_id
#       json.text r.text
#     end
#   end
# end

# example from elsewhere

# json.array!(@users) do |user|
#     json.name user.name
#
#     json.reservations do
#         json.array!(user.reservations) do |reservation|
#             json.restaurant reservation.restaurant.name
#             json.reservation_time reservation.time
#             json.name user.name
#         end
#     end
# end
