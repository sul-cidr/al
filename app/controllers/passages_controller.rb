class PassagesController < ApplicationController
  respond_to :json

  def index

    @passages = Passage.order(:work_id).all


    if params[:q]
      @passages = Passage.search(:include => [:text]) do
        keywords(params[:q])
      end
    end
  end

  # def search
  #   @search = Passage.search(:include => [:text]) do
  #     keywords(params[:q])
  #   end
  # end

end
