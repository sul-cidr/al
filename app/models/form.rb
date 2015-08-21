class Form < ActiveRecord::Base
	has_many :author_forms
	has_many :authors, :through => :author_forms
end
