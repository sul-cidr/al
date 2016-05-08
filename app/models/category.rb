# == Schema Information
#
# Table name: categories
#
#  category_id  :integer          not null, primary key
#  name         :string
#  dimension_id :integer
#  sort         :integer
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

end
