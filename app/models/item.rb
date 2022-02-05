class Item < ApplicationRecord
    validates :name, presence: true
    validates :code, presence: true
    validates :pack_number, numericality: { only_integer: true }
    validates :pack_price, numericality: { only_integer: true }
end
