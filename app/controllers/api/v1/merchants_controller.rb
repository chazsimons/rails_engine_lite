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
    if params[:name] == "" || !params.include?(:name)
      render json: { errors: {details: "A name must be provided to search" }}, status: 400
    elsif Merchant.search(params[:name]).nil?
      render json: { data: { details: "No merchant found!" } }, status: 404
    else
      render json: MerchantSerializer.new(Merchant.search(params[:name]))
    end
  end

  def find_all
    if params[:name] == "" || !params.include?(:name)
      render json: { errors: {details: "A name must be provided to search" }}, status: 400
    elsif Merchant.search_all(params[:name]) == []
      render json: { data: [] }, status: 404
    else
      render json: MerchantSerializer.new(Merchant.search_all(params[:name]))
    end
  end
end
