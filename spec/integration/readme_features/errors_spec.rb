require 'spec_helper'

describe "README Features" do
  describe "Errors" do
    let(:item_list) { ExampleCom::ItemList.new(name: 'My list') }

    it "exposes ActiveModel::Errors object" do
      expect(item_list.errors).to be_kind_of(ActiveModel::Errors)
    end

    it "loads errors from remote response" do
      stub_request(*create_item_list_request).to_return(response_with_errors)
      item_list.save

      expect(item_list.errors[:items]).to eq(["can not be empty"])
    end

    def response_with_errors
      {
        status: 422,
        body: { 
          name: "My list",
          errors: {
            items: ["can not be empty"]
          },
        }
      }
    end
  end
end
