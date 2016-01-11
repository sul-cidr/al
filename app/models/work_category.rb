class WorkCategory < ActiveRecord::Base
  belongs_to :work, :foreign_key => "work_id"
  belongs_to :category
end
