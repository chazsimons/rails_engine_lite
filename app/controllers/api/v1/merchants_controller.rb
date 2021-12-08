class Api::V1::MerchantsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    if params[:id] == 'find'
      if params[:name] == ""
        render json: { error: "A name must be provided to search" }, status: 400
      else
        render json: MerchantSerializer.new(Merchant.search(params[:name]))
      end
    else
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    end
  end
end
