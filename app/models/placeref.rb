# == Schema Information
#
# Table name: placerefs
#
#  id            :integer          not null, primary key
#  placeref_id   :integer
#  work_id       :integer
#  passage_id    :string
#  placeref      :string
#  author_id     :integer
#  place_id      :integer
#  geom_wkt      :text
#  placeref_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

# reference in a work.passage to a place

class Placeref < ActiveRecord::Base
  # self.primary_key = 'placeref_id'

  belongs_to :passage
  belongs_to :work
  belongs_to :author
  belongs_to :place, :counter_cache => true
  # has_one :place

  scope :by_place, -> (pid = nil) {
    where {place_id == pid}
  }

  scope :for_popup, -> {
    includes {work}
    includes {author}
  }

  def self.rank_places(params)
    refs = all
    # agglomerates param terms
    if params[:work_cat]
      refs = refs.joins{work.categories}.where{categories.category_id >> params[:work_cat]}
    end
    if params[:auth_cat]
      refs = refs.joins{author.categories}.where{categories.category_id >> params[:auth_cat]}
    end

    # distinct param terms; same result as agglom
    # e.g. auth_cat=30 is same as community_id = 30
    if params[:genre_id]
      refs = refs.joins{work.categories}.where{categories.category_id >> params[:genre_id]}
    end
    if params[:form_id]
      refs = refs.joins{work.categories}.where{categories.category_id >> params[:form_id]}
    end
    if params[:community_id]
      refs = refs.joins{author.categories}.where{categories.category_id >> params[:community_id]}
    end
    if params[:standing_id]
      refs = refs.joins{author.categories}.where{categories.category_id >> params[:standing_id]}
    end

    if params[:author_id]
      refs = refs.joins{author}.where{author.author_id >> params[:author_id]}
    end
    if params[:authors] # array of author_id
      refs = refs.joins{author}.where{author.standing_id >> params[:authors]}
    end
    
    if params[:work_id]
      refs = refs.joins{work}.where{work.work_id >> params[:work_id]}
    end
    counts = {}
    refs.each do |ref|
      if !counts.has_key?(ref.place_id)
        counts[ref.place_id] = 1
      else
        counts[ref.place_id] += 1
      end
    end
    counts
  end

  # placerefs in or near hood
  # def self.in_or_near(id)
  #   where {
  #       geom_wkt like 'MULTIPOINT%' and
  #       st_intersects(
  #         st_buffer( (st_geomfromtext(Area.find(id).geom_wkt)), 0.01),
  #         st_geomfromtext(geom_wkt)
  #       )
  #     # st_geomfromtext(Area.find(id).geom_wkt)
  #   }
  # end

end
