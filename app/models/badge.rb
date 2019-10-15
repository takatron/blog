class Badge < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 2 }
  has_many :users_badges
  has_many :user_ids, through: :users_badges
end
