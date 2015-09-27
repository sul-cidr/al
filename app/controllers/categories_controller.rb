class CategoriesController < ApplicationController
  respond_to do |format|
    format.json
  end

  def index
    @categories = Category.all
  end

end
