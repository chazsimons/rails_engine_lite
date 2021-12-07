class Api::V1::MerchantItemsController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.where(merchant_id: params[:merchant_id]))
  end


  private
    # def find_items
    #   @items = Item.where(merchant_id: params[:merchant_id])
    # end
    # if @items == []
    #   message = "No items were found for merchant with id: #{params[:merchant_id]}"
    #   render json: { error: message }, status: :not_found
    # else
end
