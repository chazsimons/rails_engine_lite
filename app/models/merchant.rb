class Merchant < ApplicationRecord
  has_many :items

  def self.search(search_name)
    where("name ILIKE ?", "%#{search_name}%").order('name asc').first
  end

  def self.search_all(search_name)
    where("name ILIKE ?", "%#{search_name}%").order('name asc')
  end
end
