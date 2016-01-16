# == Schema Information
#
# Table name: categories
#
#  category_id  :integer          not null, primary key
#  name         :string
#  dimension_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Category < ActiveRecord::Base

  self.primary_key = 'category_id'

  belongs_to :dimension

  has_many :author_category_rels
  has_many :authors, :through => :author_category_rels

  has_many :work_category_rels
  has_many :works, :through => :work_category_rels

  def self.by_dim(d)
    where { dimension_id == d }
  end

  # boy this sucks
  # def self.getAuthByGenre(cat)
  #   Genre.select{ |g| g.name  == cat }[0].authors
  # end
  # def self.getAuthByForm(cat)
  #   Form.select{ |f| f.name  == cat }[0].authors
  # end
  # def self.getAuthByCommunity(cat)
  #   Community.select{ |c| c.name  == cat }[0].authors
  # end
  # def self.getAuthByStanding(cat)
  #   Standing.select{ |s| s.name  == cat }[0].authors
  # end

end
