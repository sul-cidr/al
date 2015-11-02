# == Schema Information
#
# Table name: works
#
#  work_id    :integer          not null, primary key
#  title      :string
#  author_id  :integer
#  pub_year   :integer
#  subject_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Work < ActiveRecord::Base

  self.primary_key = 'work_id'

  belongs_to :author, foreign_key: :author_id
  has_many :passages
  has_many :placerefs, :through => :passages

end
