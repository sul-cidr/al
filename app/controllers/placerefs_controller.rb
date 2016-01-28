class PlacerefsController < ApplicationController

  def index
    placerefs = Placeref.for_popup.order('year')

    if params[:id]
      placerefs = placerefs.where(:placeref_id => params[:id])
    end

    if params[:place_id]
      placerefs = placerefs.by_place(params[:place_id])
    end

    # :author_id an array of >=1
    if params[:place_id] && params[:author_id]
      placerefs = placerefs.by_place_and_authors(params[:place_id],params[:author_id])
    end

    # :work_id an array of >=1
    if params[:place_id] && params[:work_id]
      placerefs = placerefs.by_place_and_works(params[:place_id],params[:work_id])
    end

    if params[:area_id]
      # TODO: join placerefs to place, return placerefs where
      # geom intersects buffered area
      placerefs = placerefs.by_area(params[:area_id])
    end

    @placerefs = placerefs

  end

end
