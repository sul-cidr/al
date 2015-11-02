# == Schema Information
#
# Table name: communities
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Community < ActiveRecord::Base
  has_many :author_communities
  has_many :authors, :through => :author_communities
end
