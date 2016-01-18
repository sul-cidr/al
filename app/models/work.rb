# == Schema Information
#
# Table name: works
#
#  work_id    :integer          not null, primary key
#  author_id  :integer
#  title      :string
#  sorter     :string
#  work_year  :integer
#  keywords   :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Work < ActiveRecord::Base
  self.primary_key = 'work_id'

  has_many :work_category_rels
  has_many :categories, :through => :work_category_rels

  belongs_to :author, foreign_key: :author_id
  has_many :passages
  has_many :placerefs, :through => :passages

  scope :by_author, -> (aid = nil) {
    where {author_id == aid}
  }

  # def self.by_cat(catid)
  #   works = Work.joins{work_category_rels.category}.where(categories.category_id >> catid)
  # end

  def self.rank_authors(params)
    works = all

    if params[:auth_cat]
      works = works.joins{author.categories}.where{categories.category_id >> params[:auth_cat]}
    end

    if params[:work_cat]
      works = Work.joins{work_category_rels.category}.where{categories.category_id >> params[:work_cat]}
    end

    counts = {}
    works.each do |work|
      if !counts.has_key?(work.author_id)
        counts[work.author_id] = 1
      else
        counts[work.author_id] += 1
      end
    end
    counts
  end

  def sortable_title
    self.title.sub(/^(the|a|an)\s+/i, '')
  end

end
