class PlacesController < ApplicationController
  respond_to :json

  def index
    # @places = Place.order(:prefname).all

    counts = Placeref.rank_places(params)
    places = Place.where{place_id >> counts.keys}

    @places = places.map do |place|
      {place: place, count: counts[place.place_id]}
    end

  end

end
