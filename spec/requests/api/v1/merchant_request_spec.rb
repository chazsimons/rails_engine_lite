require 'rails_helper'

RSpec.describe 'Merchant Request' do
  it 'sends a list of merchants' do
    create_list(:merchant, 5)
    get '/api/v1/merchants'

    expect(response).to be_successful

    parsed = JSON.parse(response.body, symbolize_names: true)
    expect(parsed[:data].count).to eq(5)
    merchants = parsed[:data]

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'can send a single merchant' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    parsed = JSON.parse(response.body, symbolize_names: true)
    merchant = parsed[:data]

    expect(response).to be_successful
    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
  end

  it 'returns an error if no merchant matches the id' do
    id = create(:merchant).id
    invalid_id = id + 1

    get "/api/v1/merchants/#{invalid_id}"

    parsed = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(404)
    expect(parsed).to have_key(:errors)
    expect(parsed[:errors][:details]).to eq("No merchant matches this id")
  end

  it 'can return all items of a given merchant' do
    merchant = Merchant.create({name: "Big Dave's House of Pickles"})
    merchant_2 = Merchant.create({name: "Bigger Dave's Pickle Palace"})
    item_1 = merchant.items.create({name: "Pickle Dress", description: "Dress for big dill nights", unit_price: 9.99})
    item_2 = merchant.items.create({name: "Pickles", description: "Just tasty pickles", unit_price: 0.99})
    item_3 = merchant_2.items.create({name: "Pickled Potatoes", description: "Great for potato salad", unit_price: 2.99})

    get "/api/v1/merchants/#{merchant.id}/items"

    parsed = JSON.parse(response.body, symbolize_names: true)
    items = parsed[:data]

    expect(items.count).to eq(2)
    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
      expect(item[:attributes][:merchant_id]).to eq(merchant.id)
    end
  end

  it 'returns 404 if no items are found' do
    merchant = Merchant.create({name: "Big Dave's House of Pickles"})
    get "/api/v1/merchants/#{merchant.id}/items"

    parsed_response = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(404)
    expect(parsed_response).to have_key(:errors)
    expect(parsed_response[:errors][:details]).to eq("No items were found for merchant with id: #{merchant.id}")
  end

  it 'can find a single merchant that matches search terms' do
    merchant_1 = Merchant.create({name: "Big Dave's House of Pickles"})
    merchant_2 = Merchant.create({name: "Bigger Dave's Pickle Palace"})
    merchant_3 = Merchant.create({name: "Lots o' Comics"})
    merchant_4 = Merchant.create({name: "Haha's Funny Books"})
    merchant_5 = Merchant.create({name: "Kindo' alot of Books"})

    get "/api/v1/merchants/find?name=books"

    parsed = JSON.parse(response.body, symbolize_names: true)
    found_merchant = parsed[:data]

    expect(response).to be_successful
    expect(found_merchant[:id]).to be_a(String)
    expect(found_merchant[:attributes][:name]).to eq(merchant_4.name)
  end

  it 'returns an error if no merchant was found' do
    merchant_3 = Merchant.create({name: "Lots o' Comics"})
    merchant_4 = Merchant.create({name: "Haha's Funny Books"})
    merchant_5 = Merchant.create({name: "Kindo' alot of Books"})

    get "/api/v1/merchants/find?name=bill"
    parsed = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(404)
    expect(parsed).to have_key(:data)
    expect(parsed[:data][:details]).to eq("No merchant found!")
  end

  it 'returns an error if no merchant is provided' do
    merchant_3 = Merchant.create({name: "Lots o' Comics"})
    merchant_4 = Merchant.create({name: "Haha's Funny Books"})
    merchant_5 = Merchant.create({name: "Kindo' alot of Books"})

    get "/api/v1/merchants/find?name="

    expect(response.status).to eq(400)
    parsed = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(400)
    expect(parsed).to have_key(:errors)
    expect(parsed[:errors][:details]).to eq('A name must be provided to search')
  end

  it 'returns an error if no param is provided' do
    merchant_3 = Merchant.create({name: "Lots o' Comics"})
    merchant_4 = Merchant.create({name: "Haha's Funny Books"})
    merchant_5 = Merchant.create({name: "Kindo' alot of Books"})

    get "/api/v1/merchants/find"
    parsed = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(400)
    expect(parsed).to have_key(:errors)
    expect(parsed[:errors][:details]).to eq('A name must be provided to search')
  end

  it 'can find all merchants matching a keyword' do
    merchant_1 = Merchant.create({name: "Big Dave's House of Pickles"})
    merchant_2 = Merchant.create({name: "Bigger Dave's Pickle Palace"})
    merchant_3 = Merchant.create({name: "Pick yo' Comics"})
    merchant_4 = Merchant.create({name: "Haha's Funny Books"})

    get "/api/v1/merchants/find_all?name=pick"

    parsed = JSON.parse(response.body, symbolize_names: true)
    found_merchants = parsed[:data]

    expect(response).to be_successful
    found_merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'returns an empty array if no merchants were found' do
    merchant_1 = Merchant.create({name: "Big Dave's House of Pickles"})
    merchant_2 = Merchant.create({name: "Bigger Dave's Pickle Palace"})
    merchant_3 = Merchant.create({name: "Pick yo' Comics"})
    merchant_4 = Merchant.create({name: "Haha's Funny Books"})

    get "/api/v1/merchants/find_all?name=diamond"

    parsed = JSON.parse(response.body, symbolize_names: true)
    found_merchants = parsed[:data]

    expect(response.status).to eq(404)
    expect(found_merchants).to eq([])
    # expect(found_merchants[:details]).to eq("No merchant(s) found!")
  end

  it 'returns an error if no data is provided to search' do
    merchant_1 = Merchant.create({name: "Big Dave's House of Pickles"})
    merchant_2 = Merchant.create({name: "Bigger Dave's Pickle Palace"})
    get "/api/v1/merchants/find_all?name="

    parsed = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(400)
    expect(parsed).to have_key(:errors)
    expect(parsed[:errors][:details]).to eq("A name must be provided to search")
  end
end
