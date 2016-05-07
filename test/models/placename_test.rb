# == Schema Information
#
# Table name: placenames
#
#  id           :integer          not null
#  placename_id :string           primary key
#  placename    :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class PlacenameTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
