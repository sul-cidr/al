class PlacesController < ApplicationController
	respond_to :json

	def index
		@places = Place.order(:names).all
	end

  def areas
  end
  
end