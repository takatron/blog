class Comment < ActiveRecord::Base
  validates :content, presence: true, length: { minimum: 2 }
  belongs_to :post
  belongs_to :user
  has_many :votes, as: :voteable
end
