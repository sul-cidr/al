class AuthorsController < ApplicationController
	respond_to :json

	def index
    @authors = Author.order(:surname).all
	end

  def show
    # something here to put author detail view in #authors-region
  end

end

