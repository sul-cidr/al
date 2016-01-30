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
  has_many :places, :through => :passages

  has_many :author_category_rels
  has_many :categories, :through => :author_category_rels

  has_many :author_image_rels
  has_many :images, :through => :author_image_rels

  def to_s
    "#{prefname}"
  end


end
