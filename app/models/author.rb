class Author < ActiveRecord::Base

	self.primary_key = 'author_id'

	has_many :author_genres
	has_many :genres, :through => :author_genres
	has_many :author_forms
	has_many :forms, :through => :author_forms
	has_many :author_communities
	has_many :communities, :through => :author_communities
	has_many :author_standings
	has_many :standings, :through => :author_standings

	has_many :works
	has_many :passages, :through => :works

  def to_s
  "#{prefname}"
  end

end
