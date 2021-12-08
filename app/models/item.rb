class Item < ApplicationRecord
  belongs_to :merchant

  def self.search(search_name)
    if search_name == ""
      "A name must be provided"
    else
      where("name ILIKE ?", "%#{search_name}%").order('name asc')
    end
  end
end
