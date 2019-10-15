class Post < ActiveRecord::Base
  validates :title, presence: true, length: { in: 3..200 }, uniqueness: true
  validates :content, presence: true, uniqueness: true
  has_many :comments
  has_many :posts_categories
  has_many :categories, through: :posts_categories
  has_many :votes, as: :voteable
end