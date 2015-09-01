# == Schema Information
#
# Table name: places
#
#  id         :integer          not null
#  place_id   :integer          primary key
#  source     :string
#  geom_wkt   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  latitude   :float
#  longitude  :float
#  names      :string
#

require 'test_helper'

class PlaceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
