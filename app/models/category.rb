class Category < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 2 }
  has_many :posts_categories
  has_many :posts, through: :posts_categories
end
