require 'rails_helper'

RSpec.describe 'Merchant Request' do
  it 'sends a list of merchants' do
    create_list(:merchant, 5)
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    expect(merchants.count).to eq(5)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(Integer)
      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_a(String)
    end
  end

  it 'can send a single merchant' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchant).to have_key(:name)
    expect(merchant[:name]).to be_a(String)
  end

  it 'can return all items of a given merchant' do
    merchant = Merchant.create({name: "Big Dave's House of Pickles"})
    merchant_2 = Merchant.create({name: "Bigger Dave's Pickle Palace"})
    item_1 = merchant.items.create({name: "Pickle Dress", description: "Dress for big dill nights", unit_price: 9.99})
    item_2 = merchant.items.create({name: "Pickles", description: "Just tasty pickles", unit_price: 0.99})
    item_3 = merchant_2.items.create({name: "Pickled Potatoes", description: "Great for potato salad", unit_price: 2.99})

    get "/api/v1/merchants/#{merchant.id}/items"

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items.count).to eq(2)
    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(Integer)
      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)
      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)
      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to be_a(Integer)
      expect(item[:merchant_id]).to eq(merchant.id)
    end
  end

  xit 'returns 404 if no items are found' do
    merchant = Merchant.create({name: "Big Dave's House of Pickles"})
    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response.status).to eq(404)
    expect(response.body).to eq("No items were found for merchant with id:#{merchant.id}")
  end
end
