class CommunitiesController < ApplicationController
  respond_to do |format|
    format.json
  end

  def index
    @communities = Community.all
  end

end
