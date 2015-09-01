# == Schema Information
#
# Table name: works
#
#  work_id    :integer          not null, primary key
#  title      :string
#  author_id  :integer
#  pub_year   :integer
#  subject_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class WorkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
