class AreasController < ApplicationController
	respond_to :json

	def index
		@areas = Area.order(:name).all
	end

  def show
    # something here to put a place detail view in #places-region
  end

  
end