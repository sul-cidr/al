class WorksController < ApplicationController
  respond_to do |format|
    format.json
  end

  def index
    works = Work.all.sort_by {|w| w.sortable_title}

    if params[:work_id]
      works = Work.where(:work_id => params[:work_id])
    end

    @works = works

  end


end
