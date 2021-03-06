require 'rails_helper'

RSpec.describe Merchant do
  describe 'relationships' do
    it { should have_many(:items) }
  end

  describe '#class_methods' do
    it 'returns a single merchant from a case-insensitive keyword search by name' do
      merchant_1 = Merchant.create({name: "Big Dave's House of Pickles"})
      merchant_2 = Merchant.create({name: "Bigger Dave's Pickle Palace"})
      merchant_3 = Merchant.create({name: "Lots o' Comics"})
      merchant_4 = Merchant.create({name: "Haha's Funny Comic Books"})
      merchant_5 = Merchant.create({name: "Kindo' alot of Comics"})

      results = Merchant.search("comic")
      expected = merchant_4.name

      expect(results.name).to eq(expected)
    end

    it 'returns merchants matching a case-insensitive keyword search by name' do
      merchant_1 = Merchant.create({name: "Big Dave's House of Pickles"})
      merchant_2 = Merchant.create({name: "Bigger Dave's Pickle Palace"})
      merchant_3 = Merchant.create({name: "Pick Your Path Adventure Store"})
      merchant_4 = Merchant.create({name: "Haha's Funny Comic Books"})

      results = Merchant.search_all("pick")
      expected = [merchant_1, merchant_2, merchant_3]

      expect(results).to eq(expected)
    end
  end
end
