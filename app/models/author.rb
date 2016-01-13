# == Schema Information
#
# Table name: authors
#
#  author_id    :integer          not null, primary key
#  prefname     :string
#  surname      :string
#  middle       :string
#  given        :string
#  birth_date   :date
#  death_date   :date
#  birth_year   :integer
#  death_year   :integer
#  community_id :integer
#  standing_id  :integer
#  viaf_id      :integer
#  wiki_id      :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Author < ActiveRecord::Base

  self.primary_key = 'author_id'

  has_many :works
  has_many :passages, :through => :works
  has_many :placerefs, :through => :passages

  def to_s
    "#{prefname}"
  end

  def places
    Place.joins('join placerefs on placerefs.place_id = places.place_id')
      .joins('join passages on passages.passage_id = placerefs.passage_id')
      .joins('join works on works.work_id = passages.work_id')
      .joins('join authors on authors.author_id = works.author_id')
      .where("authors.author_id = #{author_id}")

    # alternate if rails handles ids:
    # Place.joins{placerefs.passages.works.authors}.where{author=self}

  end

end
