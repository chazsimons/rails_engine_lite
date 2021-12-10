class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  # before_destroy :check_invoice_items, prepend: true
  #
  # private
  # def check_invoice_items
  #   code to check if invoice still has items, destroying if not
  # end
end
