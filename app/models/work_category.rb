# == Schema Information
#
# Table name: work_categories
#
#  id          :integer          not null, primary key
#  work_id     :integer
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class WorkCategory < ActiveRecord::Base
  belongs_to :work, :foreign_key => "work_id"
  belongs_to :category
end
