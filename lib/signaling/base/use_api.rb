module Signaling::Base::UseApi
  extend ActiveSupport::Concern

  module ClassMethods
    def use_api(api)
      @api = api
    end

    def api
      @api or raise "API is not set for #{self.name}"
    end

    def connection
      api.connection
    end
  end
end
