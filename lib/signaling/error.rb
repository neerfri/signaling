require 'faraday'

module Signaling
  module Error
    class UnprocessableEntity < Faraday::Error::ClientError; end
    class Forbidden < Faraday::Error::ClientError; end
  end
end
