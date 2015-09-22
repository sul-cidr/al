class WorksController < ApplicationController
  respond_to do |format|
    format.json
  end

  def index
    @works = Work.order(:title).all
  end


end
