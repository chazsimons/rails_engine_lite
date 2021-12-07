require 'rails_helper'

RSpec.describe 'Item Requests' do
  it 'can send a list of items' do
    create_list(:merchant, 10)
    create_list(:item, 10)

    get '/api/v1/items'

    expect(response).to be_successful
    parsed = JSON.parse(response.body, symbolize_names: true)
    items = parsed[:data]
    expect(items.count).to eq(10)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end
  end

  it 'can send a single item' do
    merchant = Merchant.create({name: "Big Dave's House of Pickles"})
    item_1 = merchant.items.create({name: "Pickle Dress", description: "Dress for big dill nights", unit_price: 9.99})
    item_2 = merchant.items.create({name: "Pickles", description: "Just tasty pickles", unit_price: 0.99})

    get "/api/v1/items/#{item_1.id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)
    # require "pry"; binding.pry
    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a(String)
    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)
    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)
  end

  it 'can create a new item' do
    merchant = Merchant.create({name: "Lots o' Comics"})
    item_params = {"name": 'Avengers 1', "description": 'The very first issue of Avengers', 'unit_price': 1964.99, "merchant_id": merchant.id}
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    new_item = Item.last

    expect(response).to be_successful
    expect(response.status).to eq(201)
    expect(new_item.name).to eq(item_params[:name])
    expect(new_item.description).to eq(item_params[:description])
    expect(new_item.unit_price).to eq(item_params[:unit_price])
    expect(new_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it 'can update a single item' do
    merchant = Merchant.create({name: "Haha's Funny Books"})
    item = merchant.items.create({"name": 'Avengers 1', "description": 'The very first issue of Avengers', 'unit_price': 1964.99})
    update_params = {"unit_price": 20_000.01}
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: update_params)

    expect(response).to be_successful

    parsed = JSON.parse(response.body, symbolize_names: true)
    updated_item = parsed[:data][:attributes]

    expect(updated_item[:unit_price]).to eq(20_000.01)
  end

  it 'can delete a single item' do
    merchant = Merchant.create({name: "Haha's Funny Books"})
    item = merchant.items.create({"name": 'Avengers 1', "description": 'The very first issue of Avengers', 'unit_price': 1964.99})
    item_2 = merchant.items.create({"name": 'Avengers 700', "description": 'The 700th issue of Avengers', 'unit_price': 9.99})

    delete "/api/v1/items/#{item_2.id}"

    expect(response).to be_successful
    expect(response.status).to eq(204)
    expect(response.body).to be_empty
  end
end
