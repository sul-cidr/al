class StandingsController < ApplicationController
  respond_to do |format|
    format.json
  end

  def index
    @standings = Standing.all
  end

end
