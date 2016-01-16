# == Schema Information
#
# Table name: communities
#
#  community_id   :integer
#  name           :string
#  start_earliest :integer
#  start_latest   :integer
#  stop_earliest  :integer
#  stop_latest    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Community < ActiveRecord::Base
  has_many :author_communities
  has_many :authors, :through => :author_communities
end
