class WorksController < ApplicationController
  respond_to :json

  def index
    @works = Work.order(:title).all
  end


end
