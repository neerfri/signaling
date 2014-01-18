require 'faraday/response/raise_error'

module Signaling
  module FaradayMiddleware
    class RaiseError < ::Faraday::Response::RaiseError
      def on_complete(env)
        case env[:status]
        when 422
          raise Signaling::Error::UnprocessableEntity, response_values(env)
        when 403
          raise Signaling::Error::Forbidden, response_values(env)
        else
          super
        end
      end
    end
  end
end
