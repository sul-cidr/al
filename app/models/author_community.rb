# == Schema Information
#
# Table name: author_communities
#
#  id           :integer          not null, primary key
#  author_id    :integer
#  community_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class AuthorCommunity < ActiveRecord::Base
	belongs_to :author, :foreign_key => "author_id" 
	belongs_to :community
end
