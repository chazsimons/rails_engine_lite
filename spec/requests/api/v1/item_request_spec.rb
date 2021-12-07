require 'rails_helper'

RSpec.describe 'Item Requests' do
  it 'can send a list of items' do
    create_list(:merchant, 10)
    create_list(:item, 10)

    get '/api/v1/items'

    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)

    expect(items.count).to eq(10)
    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(Integer)
      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)
      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)
      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)
      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to be_a(Integer)
    end
  end
end
