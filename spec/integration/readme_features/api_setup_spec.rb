require 'spec_helper'

describe "README features" do
  describe 'Api setup' do
    let(:api_base_url) { "http://example.com/api" }
    let(:logger) { double("logger", info: nil, debug: nil) }

    it "sets base url" do
      expect(new_api.connection.url_prefix.to_s).to eq(api_base_url)
    end

    it "allows setting a logger" do
      stub_request(:get, api_base_url)

      logger.should_receive(:info)
      new_api(logger: logger).connection.get('')
    end

    it "yields block with faraday builder" do
      expect {|b| new_api(&b) }.to yield_with_args(Faraday::Connection)
    end

    def new_api(options = {}, &block)
      Signaling::Api.new({url: api_base_url}.merge(options), &block)
    end
  end
end
