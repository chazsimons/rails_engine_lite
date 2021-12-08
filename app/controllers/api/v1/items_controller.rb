class Api::V1::ItemsController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def find_all
    if params[:name] == ""
      render json: { errors: { details: "A name must be provided to search" }}, status: 400
    else
      render json: ItemSerializer.new(Item.search(params[:name]))
    end
  end

  def create
    if Item.new(item_params).save
      render json: ItemSerializer.new(Item.create(item_params)), status: 201
    else
      render json: {errors: {details: "Unable to create item. Please provide name, description, and unit price"}}, status: 400
    end
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
