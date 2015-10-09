class AreasController < ApplicationController
	respond_to :json

	def index
		@areas = Area.order(:name).all

    if params[:area_type]
      @areas = areas.of_type(params[:area_type])
    end

    # hoods within a borough
    if params[:in_id]
      @areas = areas.child_of(params[:in_id])
    end

	end

  def show
    # something here to put a place detail view in #places-region
  end


end
