require 'spec_helper'

describe "README features" do
  describe "Custom actions" do
    let(:custom_path) { 'accounts/:account_id/item_lists.json' }

    around do |example|
      begin
        ExampleCom::ItemList.define_action :index, method: :get, path: custom_path
        example.run
      ensure
        ExampleCom::ItemList.define_action :index, method: :get, path: ':route_key.json'
      end
    end

    before do
      stub_request(:get, expected_item_lists_path)
    end

    specify "will change the URL for the request" do
      ExampleCom::ItemList.all(account_id: '123')
      expect_request(:get, path: expected_item_lists_path)
    end

    specify "are isolated to class" do
      expect(ExampleCom::Item._defined_actions[:index][:path]).to eq(':route_key.json')
    end

    def expected_item_lists_path
      example_com_build_url('accounts/123/item_lists.json')
    end

  end
end

