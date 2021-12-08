class Api::V1::ItemsController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    if params[:id] == 'find_all'
      if params[:name] == ""
        render json: { error: "A name must be provided to search" }, status: 400
      else
        render json: ItemSerializer.new(Item.search(params[:name]))
      end
    else
      render json: ItemSerializer.new(Item.find(params[:id]))
    end
  end

  def create
    render json: ItemSerializer.new(Item.create(item_params)), status: 201
  end

  def update
    render json: ItemSerializer.new(Item.update(params[:id], item_params))
  end

  def destroy
    render json: Item.destroy(params[:id])
    head :no_content
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
