# == Schema Information
#
# Table name: forms
#
#  form_id    :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Form < ActiveRecord::Base
  has_many :work_form_rels
  has_many :works, :through => :work_form_rels
  
  has_many :authors, :through => :works
  has_many :passages, :through => :works
  has_many :places, :through => :passages
end
