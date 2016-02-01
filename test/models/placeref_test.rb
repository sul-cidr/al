# == Schema Information
#
# Table name: placerefs
#
#  id            :integer          not null
#  placeref_id   :integer          primary key
#  work_id       :integer
#  year          :integer
#  passage_id    :string
#  placeref      :string
#  author_id     :integer
#  place_id      :integer
#  geom_wkt      :text
#  placeref_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class PlacerefTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
