class WorksController < ApplicationController
  respond_to do |format|
    format.json
  end

  def index
    @works = Work.all.sort_by {|w| w.sortable_title}
  end


end
