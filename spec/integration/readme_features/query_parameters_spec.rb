require 'spec_helper'

describe "README features" do
  describe "Query parameters" do
    before do
      stub_request(:get, expected_item_lists_path)
    end

    specify "are sent to remote service" do
      ExampleCom::ItemList.all(account_id: '123')
      expect_request(:get, path: expected_item_lists_path)
    end

    def expected_item_lists_path
      example_com_build_url('item_lists.json?account_id=123')
    end

  end
end


