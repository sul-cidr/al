class PlacesController < ApplicationController
  respond_to :json

  def index
    counts = Placeref.rank_places(params)
    biocounts = Placeref.rank_bioplaces(params)
    places = Place.where{place_id >> counts.keys}

    places = places.map do |place|
    # @places = places.map do |place|
      {place: place, count: counts[place.place_id], biocount: biocounts[place.place_id]}
    end

    #
    # if params[:passages]
    #   places = Place.first
    #   # places = Place.by_passage(:passages)
    # end

    @places = places
  end

  def new
    @place = Place.new
  end

  def create
    @place = Place.new place_params
    @place.save
  end

end
