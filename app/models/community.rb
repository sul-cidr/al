class Community < ActiveRecord::Base
	has_many :author_communities
	has_many :authors, :through => :author_communities
end
