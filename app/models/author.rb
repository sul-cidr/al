class Author < ActiveRecord::Base

	self.primary_key = 'author_id'

	# has_many :works
	# has_many :passages, :through => :works

	has_and_belongs_to_many :categories, :foreign_key => :author_id
	# has_many :dimensions, :foreign_key => :author_id, :join_table => "authors_categories"
	# has_many :categories, :through => :authors_categories

  def to_s
  "#{prefname}"
  end

end
