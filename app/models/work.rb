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

  # auto-increment work_id
  before_create :set_id

  def set_id
    self.work_id = Work.maximum(:work_id).next
  end

  # compute keywords field on save
  # work_id is an integer, e.g. 20564
  after_save :update_keywords

  def update_keywords
    keyword_obj = ActiveRecord::Base.connection.exec_query('select pr.placeref,count(pr.placeref) from works w join placerefs pr on w.work_id = pr.work_id where w.work_id = '+self.work_id.to_s+' group by pr.placeref order by pr.placeref;').rows
    # puts keyword_obj.inspect
    # puts 'foo'
    self.update_columns(keywords: keyword_obj)
  end

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

  def list(options={})
    super(:only => [:work_id,:title])
  end

end
