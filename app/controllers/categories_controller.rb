class CategoriesController < ApplicationController
  # respond_to do |format|
  #   format.json
  # end

  def index
    @categories = Category.joins(:dimension).all
    # @categories = Category.all
  end

end
