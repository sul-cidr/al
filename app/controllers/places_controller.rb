class PlacesController < ApplicationController
  respond_to :json

  def index
    # @places = Place.order(:prefname).all

    @places = Place.joins(:placerefs)
      .select('places.place_id,places.geom_wkt,places.prefname,placerefs_count,array_agg(author_id) AS auth_array')
      .group('places.place_id,places.geom_wkt,places.prefname,placerefs_count')


    # if params[:author_id]
    #   # places = places.where(prefname: 'Greenwich')
    #   # places = places.where('placerefs_count = 2 ')
    #   # places = places.where("10377 = ANY(auth_array)")
    #   # places = places.where(params[:author_id],' in auth_array'))
    #   # places = places.where('auth_array.include?',params[:author_id] )
    #   places = places.by_author(params[:author_id])
    # end
    #
    # if params[:genre_id]
    #   places = place.by_genre(params[:genre_id])
    # end
    #
    # if params[:form_id]
    #   places = place.by_form(params[:form_id])
    # end
    #
    # if params[:community_id]
    #   places = place.by_community(params[:community_id])
    # end
    #
    # if params[:standing_id]
    #   places = place.by_standing(params[:standing_id])
    # end
    #
    # @places = places

  end

end
