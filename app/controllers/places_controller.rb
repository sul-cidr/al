class PlacesController < ApplicationController
	respond_to :json

	def index
		@places = Place.all
	end

end