require 'faraday'

module ExampleCom
  Api = Signaling::Api.new(url: "http://example.com/api/")

  def self.use_relative_model_naming?
    true
  end
end
