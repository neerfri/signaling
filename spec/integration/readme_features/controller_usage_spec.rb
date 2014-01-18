require 'spec_helper'

describe "README Features" do
  describe "Usage in rails controllers" do
    let(:controller) { ItemListsController.new }

    describe "#index" do
      it "finds all item lists" do
        stub_request(*index_item_list_request).to_return(successful_response)

        get :index
        expect(assigns(:item_lists).count).to eq(2)
      end

      def successful_response
        { status: 200, body: [{}, {}] }
      end
    end

    describe "#new" do
      it "assigns a new item list" do
        get :new
        expect(assigns(:item_list)).to be_kind_of(ExampleCom::ItemList)
      end
    end

    describe "#create" do
      let(:item_list_param) { { name: "my list" } }

      before do
        stub_request(*create_item_list_request).to_return(successful_response)
      end

      it "creates a new item list on remote service" do
        post :create, item_list: item_list_param
        expect_request(:post, path: item_lists_path, body: expected_body)
      end

      def expected_body
        { item_list: item_list_param }
      end
    end

    describe "#show / #edit" do
      it "finds the item list" do
        stub_request(*get_item_list_request).to_return(successful_response)

        get :show, { id: '1' }
        expect_request(:get, path: item_list_path)
      end
    end

    describe "#update" do
      let(:item_list_param) { { name: 'my list' } }

      before do
        stub_request(*update_item_list_request).to_return(successful_response)
      end

      it "does NOT fetch the item list from remote" do
        put :update, { id: '1', item_list: {} }
        expect_no_request(:get, path: item_list_path)
      end

      it "updates record on remote service" do
        put :update, { id: '1', item_list: item_list_param }

        expected_body = { item_list: item_list_param }
        expect_request(:put, path: item_list_path, body: expected_body)
      end
    end

    describe "#destroy" do
      it "destroys record on remote" do
        stub_request(*destroy_item_list_request).to_return(successful_response)
        delete :destroy, { id: '1' }

        expect_request(:delete, path: item_list_path)
      end
    end

    def successful_response
      { status: 200, body: { id: '1' } }
    end

    %w(get post put delete).each do |http_method|
      define_method(http_method) do |action, params = {}|
        controller.process(action, params)
      end
    end

    def assigns(name)
      controller.instance_variable_get("@#{name}")
    end
  end
end
