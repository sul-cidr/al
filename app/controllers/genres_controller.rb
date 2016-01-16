class GenresController < ApplicationController
  respond_to do |format|
    format.json
  end

  def index
    @genres = Genre.all
  end

end
