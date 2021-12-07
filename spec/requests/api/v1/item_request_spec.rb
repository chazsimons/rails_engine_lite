require 'rails_helper'

RSpec.describe 'Item Requests' do
  it 'can send a list of items' do
    create_list(:item, 10)

    visit '/api/v1/items'

    expect(response).to be_successful
  end
end
