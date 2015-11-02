module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    mapping do
      indexes :text
      indexes :text_suggest, type: 'completion', payloads: true
    end


    def as_indexed_json(options={})
      as_json.merge \
      text_suggest: {
        input:  text,
        output: text,
        payload: { url: "/passages/#{passage_id}" }
      }
    end

    def self.search(query)
      # ...
    end

  end

end
