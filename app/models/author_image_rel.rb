class AuthorImageRel < ActiveRecord::Base

  belongs_to :author, :foreign_key => "author_id"
  belongs_to :image, :foreign_key => "image_id"

end
