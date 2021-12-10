class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, :dependent => :destroy
  has_many :invoices, through: :invoice_items
  validates_presence_of :name, :description, :unit_price

  def self.search(search_name)
    where("name ILIKE ?", "%#{search_name}%").order('name asc').first
  end

  def self.search_all(search_name)
    where("name ILIKE ?", "%#{search_name}%").order('name asc')
  end

  def self.price_search(prices)
    if prices.include?(:min_price) && !prices.include?(:max_price)
      where("unit_price >= ?", prices[:min_price].to_f).order("name asc")
    elsif prices.include?(:max_price) && !prices.include?(:min_price)
      where("unit_price <= ?", prices[:max_price].to_f).order("name asc")
    elsif prices.include?(:min_price) && prices.include?(:max_price)
      where("unit_price BETWEEN ? AND ?", prices[:min_price].to_f, prices[:max_price].to_f).order("name asc")
    end
  end
end
