# == Schema Information
#
# Table name: work_genre_rels
#
#  id         :integer          not null, primary key
#  work_id    :integer
#  genre_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class WorkGenreRel < ActiveRecord::Base
  belongs_to :work
  belongs_to :genre
end
