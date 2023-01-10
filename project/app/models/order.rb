class Order < ApplicationRecord
    validates :address, :phone, :post, presence: true
    belongs_to :user
end
