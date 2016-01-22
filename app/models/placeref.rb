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
  self.primary_key = 'placeref_id'

  belongs_to :passage
  belongs_to :work
  belongs_to :author
  belongs_to :place, :counter_cache => true
  # has_one :place

  scope :by_place, -> (pid = nil) {
    where {place_id == pid}
  }

  scope :by_place_and_author, -> (pid = nil, aid = nill) {
    where {place_id == pid && author_id == aid}
  }

  scope :for_popup, -> {
    includes {work}
    includes {author}
  }

  def self.rank_places(params)
    refs = Placeref.all
    # agglomerates param terms
    if params[:work_cat]
      refs = refs.joins{work.categories}.where{categories.category_id >> params[:work_cat]}
    end
    if params[:auth_cat]
      refs = refs.joins{author.categories}.where{categories.category_id >> params[:auth_cat]}
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

  def self.rank_bioplaces(params)
    refs = Placeref.where(placeref_type:'bio')
    # agglomerates param terms
    if params[:work_cat]
      refs = refs.joins{work.categories}.where{categories.category_id >> params[:work_cat]}
    end
    if params[:auth_cat]
      refs = refs.joins{author.categories}.where{categories.category_id >> params[:auth_cat]}
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

    biocounts = {}

    refs.each do |ref|
      if !biocounts.has_key?(ref.place_id)
        biocounts[ref.place_id] = 1
      else
        biocounts[ref.place_id] += 1
      end
    end
    biocounts
  end

end
