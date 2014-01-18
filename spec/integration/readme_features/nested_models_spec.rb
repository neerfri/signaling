require 'spec_helper'

describe "README features" do
  describe "Nested models" do
    let(:item_hash) { {name: 'item 1'} }
    let(:item_list) { ExampleCom::ItemList.new(items: [item_hash]) }

    context "with a new record" do
      before do
        stub_request(*create_item_list_request).to_return(successful_response)
      end

      it "converts items" do
        expect(item_list.items.first).to be_kind_of(ExampleCom::Item)
      end

      it "sends items as hashes to the remote service" do
        item_list.save
        expect_request(:post, path: item_lists_path, body: expected_body)
      end

      def expected_body
        {item_list: { name: nil, items: [item_hash]}}
      end
    end

    context "with a record from the remote service" do
      let(:item_list) { ExampleCom::ItemList.find(1) }

      before do
        stub_request(*get_item_list_request).to_return(successful_response)
        stub_request(*update_item_list_request).to_return(successful_response)
      end

      it "converts items" do
        expect(item_list.items.first).to be_kind_of(ExampleCom::Item)
      end

      it "sends items as hashes to the remote service" do
        new_items_array = [item_hash, {name: 'item 2'}]
        item_list.update_attributes(items: new_items_array)

        expected_body = {item_list: { items: new_items_array}}
        expect_request(:put, path: item_list_path, body: expected_body)
      end
    end

    def successful_response
      { status: 200, body: { id: '1', items: [item_hash] } }
    end

  end
end
