# == Schema Information
#
# Table name: areas
#
#  id         :integer          not null, primary key
#  name       :string
#  area_type  :string
#  altnames   :string
#  geom_wkt   :text
#  geom_point :point            point, 0
#  geom_mpoly :geometry({:srid= multipolygon, 4326
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class AreaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
