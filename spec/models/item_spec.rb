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
  end
end
