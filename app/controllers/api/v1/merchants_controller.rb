class Api::V1::MerchantsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    if Merchant.exists?(params[:id])
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    else
      render json: { errors: { details: "No merchant matches this id" }}, status: 404
    end
  end

  def find
    if params[:name] == ""
      render json: { errors: {details: "A name must be provided to search" }}, status: 400
    else
      render json: MerchantSerializer.new(Merchant.search(params[:name]))
    end
  end
end
