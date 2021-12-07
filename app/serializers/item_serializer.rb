class ItemSerializer
  include JSONAPI::Serializer
  attributes :name, :unit_price, :description, :merchant_id
  # belongs_to :merchant
end
