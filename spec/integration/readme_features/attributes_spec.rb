require 'spec_helper'

describe "README features" do
  describe "attribtues" do
    describe ":param_name option" do
      let(:item_list) { ExampleCom::ItemList.new(tags: ['tag1']) }

      before do
        stub_request(*create_item_list_request).to_return(successful_response)
        stub_request(*update_item_list_request).to_return(successful_response)
      end

      it "changes remote attribute name on #save" do
        item_list.save

        expected_body = { item_list: { name: nil, list_tags: ["tag1"]}}
        expect_request(:post, path: item_lists_path, body: expected_body)
      end

      it "changes remote attribute name on #update_attributes" do
        item_list.save
        item_list.update_attributes(tags: ['tag2'])

        expected_body = { item_list: { list_tags: ["tag2"]}}
        expect_request(:put, path: item_list_path, body: expected_body)
      end

      def successful_response
        { status: 200, body: { id: '1' } }
      end

    end
  end
end

