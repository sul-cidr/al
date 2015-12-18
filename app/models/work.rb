# == Schema Information
#
# Table name: works
#
#  work_id    :integer          not null, primary key
#  author_id  :integer
#  title      :string
#  sorter     :string
#  work_year  :integer
#  categories :integer          default([]), is an Array
#  keywords   :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Work < ActiveRecord::Base

  self.primary_key = 'work_id'

  belongs_to :author, foreign_key: :author_id
  has_many :passages
  has_many :placerefs, :through => :passages

  def sortable_title
    self.title.sub(/^(the|a|an)\s+/i, '')
  end

end
