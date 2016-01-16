# == Schema Information
#
# Table name: genres
#
#  genre_id   :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Genre < ActiveRecord::Base
  has_many :work_genre_rels
  has_many :works, :through => :work_genre_rels
  has_many :authors, :through => :works
  has_many :passages, :through => :works
  has_many :places, :through => :passages
end
