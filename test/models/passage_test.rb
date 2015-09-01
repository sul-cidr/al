# == Schema Information
#
# Table name: passages
#
#  passage_id :string           not null, primary key
#  work_id    :integer
#  text       :text
#  placerefs  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class PassageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
