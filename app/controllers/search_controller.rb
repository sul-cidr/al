class SearchController < ApplicationController

  def search
    if params[:q].nil?
      @passages = []
    else
      @passages = Passage.search params[:q]
    end
  end

end
