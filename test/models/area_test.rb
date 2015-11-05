# == Schema Information
#
# Table name: areas
#
#  id             :integer          not null, primary key
#  prefname       :string
#  area_type      :string
#  geom_poly_wkt  :text
#  geom_point_wkt :text
#  parent_id      :integer
#  geom_poly      :geometry({:srid= polygon, 4326
#  geom_point     :geometry({:srid= point, 4326
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class AreaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
