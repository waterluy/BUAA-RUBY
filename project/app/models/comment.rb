class Comment < ApplicationRecord
  belongs_to :product
  belongs_to :user
  validates_presence_of :content
end
