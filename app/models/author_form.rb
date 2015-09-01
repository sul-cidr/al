# == Schema Information
#
# Table name: author_forms
#
#  id         :integer          not null, primary key
#  author_id  :integer
#  form_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AuthorForm < ActiveRecord::Base
	belongs_to :author, :foreign_key => "author_id"
	belongs_to :form
end
