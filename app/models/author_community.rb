class AuthorCommunity < ActiveRecord::Base
	belongs_to :author, :foreign_key => "author_id" 
	belongs_to :community
end
