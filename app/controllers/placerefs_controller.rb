class PlacerefsController < ApplicationController


  def index
    @placerefs = Placeref.order(:prefname).all
    respond_to do |format|
      format.json { render json: @placerefs }
    end
  end


end
