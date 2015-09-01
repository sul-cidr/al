# == Schema Information
#
# Table name: placerefs
#
#  id          :integer          not null
#  placeref_id :integer          primary key
#  prefname    :string
#  place_id    :integer
#  passage_id  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  work_id     :integer
#

require 'test_helper'

class PlacerefTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
