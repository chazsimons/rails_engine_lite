class Api::V1::MerchantItemsController < ApplicationController

  def index
    if Item.exists?(merchant_id: params[:merchant_id])
      render json: ItemSerializer.new(Item.where(merchant_id: params[:merchant_id]))
    else
      render json: { errors: { details: "No items were found for merchant with id: #{params[:merchant_id]}" }}, status: 404
    end
  end

  def show
    if Item.exists?(params[:item_id])
      render json: MerchantSerializer.new(Merchant.find(find_merchant_id))
    else
      render json: { errors: { details: "No item was found with id: #{params[:item_id]}" }}, status: 404
    end
  end

  private
    def find_merchant_id
      Item.find(params[:item_id])[:merchant_id]
    end
end
