require 'rails_helper'

RSpec.describe Item do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
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


      one_result = Item.search("aven")
      one_expected = item_1

      many_results = Item.search_all("aven")
      many_expected = [item_1, item_2]

      expect(one_result).to eq(one_expected)
      expect(many_results).to eq(many_expected)
    end

    it 'can search by prices' do
      merchant = Merchant.create({name: "Haha's Funny Books"})
      item_1 = merchant.items.create({"name": 'Avengers 1', "description": 'The very first issue of Avengers', 'unit_price': 1964.99})
      item_2 = merchant.items.create({"name": 'Young Avengers', "description": 'The next generation is here!', 'unit_price': 29.99})
      item_3 = merchant.items.create({"name": 'Watchmen', "description": 'The ground breaking graphic novel.', 'unit_price': 19.99})
      item_4 = merchant.items.create({"name": 'Hawkeye', "description": 'Now a show on Disney+', 'unit_price': 14.99})

      minimum = Item.price_search({min_price: 9.99})
      min_expected = [item_1, item_4, item_3, item_2]
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
