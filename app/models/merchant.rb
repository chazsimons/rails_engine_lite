class Merchant < ApplicationRecord
  has_many :items

  def self.search(search_name)
    where("name ILIKE ?", "%#{search_name.downcase}%").order('name asc').first
  end
end
