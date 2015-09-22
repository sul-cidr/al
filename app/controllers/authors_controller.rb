class AuthorsController < ApplicationController

  def index
    # json is _not_ used internally
    @authors = Author.order(:surname).all
    respond_to do |format|
      format.json { render json: @authors }
    end
  end

  def show
    @author = Author.where(:author_id => params[:author_id])
    respond_to do |format|
      format.json { render json: @author }
    end
  end

end



# def show
#   @article = Article.find(params[:id])
#   respond_to do |format|
#     format.html
#     format.json { render json: @article.as_json(only: [:id, :name, :content], include: [:author, {comments: {only:[:id, :name, :content]}}]) }
#   end
# end
