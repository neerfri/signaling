require 'faraday_middleware'
require_relative 'faraday_middleware/raise_error'

class Signaling::Api
  attr_reader :connection

  def initialize(options, &block)
    @connection = Faraday.new(url: options[:url]) do |conn|
      block.call(conn) if block_given?

      conn.request :multipart
      conn.request :url_encoded

      conn.use Signaling::FaradayMiddleware::RaiseError

      if options[:logger]
        conn.response :logger, options[:logger]
      end

      conn.response :mashify, mash_class: (options[:mash_class])
      conn.response :json, content_type: /\bjson$/

      conn.adapter options[:adapter] || Faraday.default_adapter
    end
  end
end
