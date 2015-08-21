class Standing < ActiveRecord::Base
	has_many :author_standings
	has_many :authors, :through => :author_standings
end
