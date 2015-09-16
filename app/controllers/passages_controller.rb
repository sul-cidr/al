class PassagesController < ApplicationController
  respond_to :json

  def index
    @passages = Passage.order(:work_id).all
  end

end
