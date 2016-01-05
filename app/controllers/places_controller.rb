class PlacesController < ApplicationController
  respond_to :json

  def index
    @places = Place.order(:prefname).all
  end

  def areas
  end

end
