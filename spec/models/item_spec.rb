require 'rails_helper'

RSpec.describe Item do
  describe 'relationships' do
    it { should belong_to(:merchant) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
  end

  describe '#class_methods' do
    it 'can perform a case-insensitive keyword search by name' do
      merchant = Merchant.create({name: "Haha's Funny Books"})
      item_1 = merchant.items.create({"name": 'Avengers 1', "description": 'The very first issue of Avengers', 'unit_price': 1964.99})
      item_2 = merchant.items.create({"name": 'Young Avengers', "description": 'The next generation is here!', 'unit_price': 29.99})
      item_3 = merchant.items.create({"name": 'Watchmen', "description": 'The ground breaking graphic novel.', 'unit_price': 19.99})
      item_4 = merchant.items.create({"name": 'Hawkeye', "description": 'Now a show on Disney+', 'unit_price': 19.99})


      results = Item.search("aven")
      expected = [item_1, item_2]

      expect(results).to eq(expected)
    end

    it 'can search by prices' do
      merchant = Merchant.create({name: "Haha's Funny Books"})
      item_1 = merchant.items.create({"name": 'Avengers 1', "description": 'The very first issue of Avengers', 'unit_price': 1964.99})
      item_2 = merchant.items.create({"name": 'Young Avengers', "description": 'The next generation is here!', 'unit_price': 29.99})
      item_3 = merchant.items.create({"name": 'Watchmen', "description": 'The ground breaking graphic novel.', 'unit_price': 19.99})
      item_4 = merchant.items.create({"name": 'Hawkeye', "description": 'Now a show on Disney+', 'unit_price': 14.99})

      minimum = Item.price_search({min_price: 9.99})
      min_expected = [item_1, item_4, item_3, item_2]
      # require "pry"; binding.pry
      expect(minimum).to eq(min_expected)

      maximum = Item.price_search({max_price: 100.00})
      max_expected = [item_4, item_3, item_2]
      expect(maximum).to eq(max_expected)

      minmax = Item.price_search({min_price: 15, max_price: 100})
      minmax_expected = [item_3, item_2]
      expect(minmax).to eq(minmax_expected)
    end
  end
end
