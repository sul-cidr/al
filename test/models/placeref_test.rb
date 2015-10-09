# == Schema Information
#
# Table name: placerefs
#
#  id            :integer          not null, primary key
#  placeref_id   :integer
#  work_id       :integer
#  passage_id    :string
#  prefname      :string
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
