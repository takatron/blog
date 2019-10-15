class User < ActiveRecord::Base
  validates :firstname, presence: true, length: { in: 2..200 }
  validates :lastname, length: { in: 2..200 }, allow_blank: true
  validates :email, presence: true, uniqueness: true
  validates :flare, length: { in: 2..200 }, allow_blank: true
  has_many :posts
  has_many :comments
  has_many :users_badges
  has_many :badges, through: :users_badges
  has_many :votes, as: :voteable
  has_secure_password validations: false
end
