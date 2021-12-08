class Item < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :name, :description, :unit_price

  def self.search(search_name)
    where("name ILIKE ?", "%#{search_name}%").order('name asc')
  end
end
