class AuthorGenre < ActiveRecord::Base
	belongs_to :author, :foreign_key => "author_id"
	belongs_to :genre
end