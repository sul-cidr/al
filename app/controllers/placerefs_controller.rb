class PlacerefsController < ApplicationController


  def index
    @placerefs = Placeref.order(:placeref).all

    respond_to do |format|
      format.json { render json: @placerefs }
    end

    if params[:in_or_near]
      @placerefs = placerefs.in_or_near(params[:in_or_near])
    end


  end


end
