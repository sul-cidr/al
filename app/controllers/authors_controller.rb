class AuthorsController < ApplicationController
	respond_to :json

	def index
		
    @authors = Author.order(:surname).all

	end

end

