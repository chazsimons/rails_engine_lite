class ItemSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :unit_price, :description
  belongs_to :merchant
end
