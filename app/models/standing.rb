# == Schema Information
#
# Table name: standings
#
#  standing_id :integer
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Standing < ActiveRecord::Base
  has_many :author_standings
  has_many :authors, :through => :author_standings
end
