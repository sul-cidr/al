class AuthorsController < ApplicationController
	respond_to :json

	def index
		@authors = Author.all
	end

  def test
    console.log 'AuthorsController'
  end


end