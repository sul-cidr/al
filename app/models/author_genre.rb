# == Schema Information
#
# Table name: author_genres
#
#  id         :integer          not null, primary key
#  author_id  :integer
#  genre_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AuthorGenre < ActiveRecord::Base
  belongs_to :author, :foreign_key => "author_id"
  belongs_to :genre
end
