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

  def sortable_title
    self.title.sub(/^(the|a|an)\s+/i, '')
  end

end
