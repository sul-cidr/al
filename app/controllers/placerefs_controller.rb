class PlacerefsController < ApplicationController

  def index
    placerefs = Placeref.all.for_popup

    if params[:id]
      placerefs = placerefs.where(:placeref_id => params[:id])
    end

    if params[:place_id]
      placerefs = placerefs.by_place(params[:place_id])
    end

    if params[:place_id] && params[:author_id]
      placerefs = placerefs.by_place_and_authors(params[:place_id],params[:author_id])
    end

    # TODO: return placerefs in works by author in category
    # if params[:place_id] && params[:auth_cat]
    #   placerefs = placerefs.by_place_and_authcat(params[:place_id],params[:auth_cat])
    # end

    # TODO: return placerefs in works in category
    # if params[:place_id] && params[:work_cat]
    #   placerefs = placerefs.by_place_and_workcat(params[:place_id],params[:auth_cat])
    # end

    if params[:area_id]
      # TODO: join placerefs to place, return placerefs where
      # geom intersects buffered area
      placerefs = placerefs.by_area(params[:area_id])
    end

    @placerefs = placerefs

  end

end
