require_relative 'application_controller'

class ItemListsController < ApplicationController
  def index
    @item_lists = ExampleCom::ItemList.all
  end

  def new
    @item_list = ExampleCom::ItemList.new
  end

  def create
    @item_list = ExampleCom::ItemList.new(item_list_params)

    if @item_list.save
      redirect_to(item_list_path(@item_list))
    else
      render 'new'
    end
  end

  def show
    @item_list = find_item_list
  end

  def edit
    @item_list = find_item_list
  end

  def update
    @item_list = ExampleCom::ItemList.new(id: params[:id])

    if @item_list.update_attributes(item_list_params)
      redirect_to item_list_path(@item_list)
    else
      render 'edit'
    end
  end


  def destroy
    ExampleCom::ItemList.destroy(params[:id])

    redirect_to item_lists_path
  end

  protected
  def find_item_list
    ExampleCom::ItemList.find(params[:id])
  end

  def item_list_params
    params[:item_list]
  end
end
