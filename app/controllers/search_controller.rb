class SearchController < ApplicationController

  def index
  # def search
    if params[:q].nil?
      @passages = []
    else
      @passages = Passage.solr_search {
        fulltext params[:q]
      }
    # render json: @passages
      # @passages = Passage.search params[:q]
      # puts @passages
    end
  end

end
