module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    mapping do
      indexes :text
    end


    # def as_indexed_json
    #   self.as_json({
    #     only: [:passage_id, :text, :work_id],
    #     include: {
    #       work: { only: :title }
    #     }
    #   })
    # end
    #
    # def self.search(query)
    #   # ...
    # end

  end

end
