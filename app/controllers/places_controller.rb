class PlacesController < ApplicationController
  respond_to :json

  def index
    # @places = Place.order(:prefname).all

    @places = Place.joins(:placerefs)
      .select('places.place_id,places.geom_wkt,places.prefname,placerefs_count,array_agg(author_id) AS auth_array')
      .group('places.place_id,places.geom_wkt,places.prefname,placerefs_count')

  end

end
