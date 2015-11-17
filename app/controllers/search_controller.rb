class SearchController < ApplicationController

  def index
  # def search
    if params[:q].nil?
      @passages = []
    else
      @passages = Sunspot.search Passage do
        fulltext params[:q] do
          highlight :text
        end
      end
      # puts @passages


    end
  end

end

# Passage.solr_search {fulltext 'river'}
