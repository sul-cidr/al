class PlacerefsController < ApplicationController

  def index
    placerefs = Placeref.all.for_popup

    if params[:place_id]
      placerefs = placerefs.by_place(params[:place_id])
    end

    @placerefs = placerefs

  end

end
