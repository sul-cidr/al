# == Schema Information
#
# Table name: forms
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Form < ActiveRecord::Base
  has_many :author_forms
  has_many :authors, :through => :author_forms
end
