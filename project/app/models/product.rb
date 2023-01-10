class Product < ApplicationRecord

    belongs_to :category
    belongs_to :color
    belongs_to :size
    has_many :cart_items, :dependent => :destroy
    has_many :collects, :dependent => :destroy
    has_many :comments, :dependent => :destroy

    validates_presence_of :name, :description, :image_url, :price
    validates_numericality_of :price
    validate :price_must_be_at_least_a_cent
    validates_uniqueness_of :name
    #validates_format_of :image_url, :with => %r{\.(git|jpg|png)$}i, :message => 'must be a URL for GIF, JPG or PNG image.'

    protected
    def price_must_be_at_least_a_cent
        errors.add(:price, 'should be at least 0.01') if price.nil? || price < 0.01
    end
end
