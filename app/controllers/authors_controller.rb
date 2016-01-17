class AuthorsController < ApplicationController
  respond_to do |format|
    format.json { render json: @authors }
  end

  def index
    # authors = Authorall
    authors = Author.order(:surname).where('author_id < 10434')

    if params[:author_id]
      authors = Author.where(:author_id => params[:author_id])
    end

    @authors = authors

  end

end
