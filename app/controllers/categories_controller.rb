class CategoriesController < ApplicationController
  respond_to :json

  def index
    @categories = Category.all
  end

end