class ImagesController < ApplicationController
  respond_to :json

  def index
    images = Image.all

    if params[:author_id]
      images = Image.where(:author_id => params[:author_id])
    end

    @images = images

  end

end
