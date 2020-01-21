class Post < ActiveRecord::Base
  validates :title, presence: true, length: { in: 3..200 }, uniqueness: true
  validates :content, presence: true, uniqueness: true

  has_many :comments
  has_many :posts_categories
  has_many :categories, through: :posts_categories
  has_many :votes, as: :voteable

  belongs_to :user

  before_create :calculate_slug

  REJECTED_CHARS = /([.@?$%&^*!])/
  REPLACED_CHARS = /([ :\-])/

  def self.paginated(page: 1, per_page: 5)
    order(created_at: :desc)
      .offset(per_page * (page - 1))
      .limit(per_page)
      .includes(:categories, :votes)
  end

  def self.find_by_id_or_slug(identifier)
    find_by(id: identifier) || find_by(slug: id)
  end

  def calculate_slug
    self.slug = title
      .downcase
      .strip
      .gsub(REPLACED_CHARS, '_')
      .gsub(REJECTED_CHARS, '')
      .gsub('__', '_')
  end
end
