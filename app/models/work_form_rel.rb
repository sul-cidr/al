# == Schema Information
#
# Table name: work_form_rels
#
#  id         :integer          not null, primary key
#  work_id    :integer
#  form_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class WorkFormRel < ActiveRecord::Base
  belongs_to :work
  belongs_to :form
end
