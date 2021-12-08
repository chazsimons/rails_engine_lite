class Api::V1::MerchantItemsController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.where(merchant_id: params[:merchant_id]))
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(find_merchant_id))
  end


  private

    def find_merchant_id
      @merchant_id = Item.find(params[:item_id])[:merchant_id]
    end
end
