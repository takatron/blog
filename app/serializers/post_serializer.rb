class PostSerializer
  attr_reader :post

  def initialize(post)
    @post = post
  end

  def serialize
    author = post.user
    {
      id: post.id,
      title: post.title,
      content: post.content,
      categories: post.categories.map { |c| c.name },
      vote_count: post.votes,
      author: {
        id: author.id,
        firstname: author.firstname,
        lastname: author.lastname
      }
    }
  end
end
