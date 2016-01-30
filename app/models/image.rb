class Image < ActiveRecord::Base

  self.primary_key = 'image_id'

  has_many :author_image_rels
  has_many :authors, :through => :author_image_rels

end
