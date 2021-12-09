require 'rails_helper'

RSpec.describe 'Item Requests' do
  it 'can send a list of items' do
    merchant = Merchant.create({name: "Haha's Funny Books"})
    item_1 = merchant.items.create({"name": 'Avengers 1', "description": 'The very first issue of Avengers', 'unit_price': 1964.99})
    item_2 = merchant.items.create({"name": 'Young Avengers', "description": 'The next generation is here!', 'unit_price': 29.99})
    item_3 = merchant.items.create({"name": 'Watchmen', "description": 'The ground breaking graphic novel.', 'unit_price': 19.99})
    item_4 = merchant.items.create({"name": 'Hawkeye', "description": 'Now a show on Disney+', 'unit_price': 19.99})

    get '/api/v1/items'

    expect(response).to be_successful
    parsed = JSON.parse(response.body, symbolize_names: true)
    items = parsed[:data]
    expect(items.count).to eq(4)

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

  it 'returns an error if not provided all attributes' do
    merchant = Merchant.create({name: "Lots o' Comics"})
    item_params = {"name": 'Avengers 1', "description": 'The very first issue of Avengers', "merchant_id": merchant.id}
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    parsed = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(400)
    expect(parsed).to have_key(:errors)
    expect(parsed[:errors][:details]).to eq("Unable to create item. Please provide name, description, and unit price")
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

  it 'can send the items merchant information' do
    merchant = Merchant.create({name: "Haha's Funny Books"})
    item = merchant.items.create({"name": 'Avengers 1', "description": 'The very first issue of Avengers', 'unit_price': 1964.99})
    item_2 = merchant.items.create({"name": 'Avengers 700', "description": 'The 700th issue of Avengers', 'unit_price': 9.99})

    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful
  end

  it 'sad path - no item is found when searching for merchant info' do
    merchant = Merchant.create({name: "Haha's Funny Books"})
    item_1 = merchant.items.create({"name": 'Avengers 1', "description": 'The very first issue of Avengers', 'unit_price': 1964.99})
    invalid_id = item_1.id + 1

    get "/api/v1/items/#{invalid_id}/merchant"
    parsed = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(404)
    expect(parsed).to have_key(:errors)
    expect(parsed[:errors][:details]).to eq("No item was found with id: #{invalid_id}")
  end

  it 'can find all items matching a searched name' do
    merchant = Merchant.create({name: "Haha's Funny Books"})
    item_1 = merchant.items.create({"name": 'Avengers 1', "description": 'The very first issue of Avengers', 'unit_price': 1964.99})
    item_2 = merchant.items.create({"name": 'Young Avengers', "description": 'The next generation is here!', 'unit_price': 29.99})
    item_3 = merchant.items.create({"name": 'Watchmen', "description": 'The ground breaking graphic novel.', 'unit_price': 19.99})
    item_4 = merchant.items.create({"name": 'Hawkeye', "description": 'Now a show on Disney+', 'unit_price': 19.99})

    get "/api/v1/items/find_all?name=avengers"

    expect(response).to be_successful
    parsed = JSON.parse(response.body, symbolize_names: true)
    found_items = parsed[:data]

    found_items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)
    end
  end

  it 'can find all items by price' do
    merchant = Merchant.create({name: "Haha's Funny Books"})
    item_1 = merchant.items.create({"name": 'Avengers 1', "description": 'The very first issue of Avengers', 'unit_price': 1964.99})
    item_2 = merchant.items.create({"name": 'Young Avengers', "description": 'The next generation is here!', 'unit_price': 29.99})
    item_3 = merchant.items.create({"name": 'Watchmen', "description": 'The ground breaking graphic novel.', 'unit_price': 19.99})
    item_4 = merchant.items.create({"name": 'Hawkeye', "description": 'Now a show on Disney+', 'unit_price': 19.99})

    get "/api/v1/items/find?min_price=9.99"
    minimum = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(minimum).to have_key(:data)
    expect(minimum[:data].count).to eq(4)

    get "/api/v1/items/find?max_price=25"
    maximum = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(maximum).to have_key(:data)
    expect(maximum[:data].count).to eq(2)

    get "/api/v1/items/find?min_price=25&max_price=9999.99"
    minmax = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(minmax).to have_key(:data)
    expect(minmax[:data].count).to eq(2)
  end

  it 'returns an error if no name is provided' do
    merchant = Merchant.create({name: "Haha's Funny Books"})
    item_1 = merchant.items.create({"name": 'Avengers 1', "description": 'The very first issue of Avengers', 'unit_price': 1964.99})
    item_2 = merchant.items.create({"name": 'Young Avengers', "description": 'The next generation is here!', 'unit_price': 29.99})
    item_3 = merchant.items.create({"name": 'Watchmen', "description": 'The ground breaking graphic novel.', 'unit_price': 19.99})
    item_4 = merchant.items.create({"name": 'Hawkeye', "description": 'Now a show on Disney+', 'unit_price': 19.99})

    get "/api/v1/items/find_all?name="

    expect(response.status).to eq(400)
    parsed = JSON.parse(response.body, symbolize_names: true)
    expect(parsed).to have_key(:errors)
    expect(parsed[:errors][:details]).to be_a(String)
    expect(parsed[:errors][:details]).to eq("A name must be provided to search")
  end

  it 'returns an error if searching by name and price' do
    merchant = Merchant.create({name: "Haha's Funny Books"})
    item_1 = merchant.items.create({"name": 'Avengers 1', "description": 'The very first issue of Avengers', 'unit_price': 1964.99})


end
