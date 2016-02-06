class AreasController < ApplicationController
	respond_to :json


	def index
		# @areas = Area.all
		@areas = Area.active
		# @areas = Area.order(:prefname).all

    if params[:area_type]
      @areas = areas.of_type(params[:area_type])
    end

    # hoods within a borough
    if params[:in_id]
      @areas = areas.child_of(params[:in_id])
    end


	end

  def new
    @area = Area.new
  end

  def create
    @area = Area.new area_params
    @area.save
  end

end
