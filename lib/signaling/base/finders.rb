module Signaling::Base::Finders
  extend ActiveSupport::Concern

  module ClassMethods
    def find(id)
      from_response(request(:show, id: id))
    end

    def all(params = {})
      from_response(request(:index, params))
    end

    def from_response(response)
      case response
      when Hash, Hashie::Mash
        self.new(response)
      when Array
        response.map {|i| from_response(i) }
      else
        response
      end
    end
  end
end
