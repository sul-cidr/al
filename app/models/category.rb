# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  dimension  :string
#

class Category < ActiveRecord::Base

  belongs_to :dimension
  
  # abandoned in favor of author_genre, etc.
  has_and_belongs_to_many :authors, :through => :authors_categories

  def self.by_dim(d)
    where { dim == d }
  end

  # boy this sucks
  def self.getAuthByGenre(cat)
    Genre.select{ |g| g.name  == cat }[0].authors
  end
  def self.getAuthByForm(cat)
    Form.select{ |f| f.name  == cat }[0].authors
  end
  def self.getAuthByCommunity(cat)
    Community.select{ |c| c.name  == cat }[0].authors
  end
  def self.getAuthByStanding(cat)
    Standing.select{ |s| s.name  == cat }[0].authors
  end

end
