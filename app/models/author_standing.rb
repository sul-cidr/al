# == Schema Information
#
# Table name: author_standings
#
#  id          :integer          not null, primary key
#  author_id   :integer
#  standing_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class AuthorStanding < ActiveRecord::Base
	belongs_to :author, :foreign_key => "author_id" 
	belongs_to :standing
end
