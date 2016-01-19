class AuthorsController < ApplicationController
  respond_to do |format|
    format.json { render json: @authors }
  end

  def index
    authors = Author.order(:surname).where('author_id < 10434')

    if params[:author_id]
      authors = Author.where(:author_id => params[:author_id])
    end

    if params[:auth_cat]
      counts = Work.rank_authors(params)
      authors = Author.where{ author_id >> counts.keys}
    end

    if params[:work_cat]
      counts = Work.rank_authors(params)
      authors = Author.where{ author_id >> counts.keys}
    end

    @authors = authors
  end

end
