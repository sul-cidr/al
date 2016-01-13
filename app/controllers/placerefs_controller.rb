class PlacerefsController < ApplicationController

  def index
    placerefs = Placeref.all.for_popup

    if params[:place_id]
      placerefs = placerefs.by_place(params[:place_id])
    end

    @placerefs = placerefs
    # respond_to do |format|
    #   format.json { render json: placerefs }
    # end

    # if params[:in_or_near]
    #   @placerefs = placerefs.in_or_near(params[:in_or_near])
    # end


  end

end
