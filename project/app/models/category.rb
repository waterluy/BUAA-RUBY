class Category < ApplicationRecord
    validates_uniqueness_of :name
    has_many :products, :dependent => :destroy
end
