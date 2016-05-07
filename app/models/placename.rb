# == Schema Information
#
# Table name: placenames
#
#  id           :integer          not null
#  placename_id :string           primary key
#  placename    :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Placename < ActiveRecord::Base
  self.primary_key = 'placename_id'

  belongs_to :placeref
  
end
