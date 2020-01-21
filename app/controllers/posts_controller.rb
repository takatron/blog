# show list of posts
class PostsController < ApplicationController
  before_action :ensure_logged_in, only:[:new, :create, :edit, :update]
  http_basic_authenticate_with name: ENV['NAME'], password: ENV['PASSWORD'], only: :create_from_api
  skip_before_action :verify_authenticity_token, only: [:create_from_api]

  def index
    @post = Post.paginated(page: page, per_page: per_page)

    respond_to do |format|
      format.html do
        @total_pages = (Post.count / per_page.to_f).ceil
      end

      format.json do
        serialized_posts = @post.map do |p|
          serialize = PostSerializer.new(p)
          serialize.serialize
        end

        render json: serialized_posts
      end
    end
  end

  def show
    @post = Post.find_by_id_or_slug(params[:id])

    if @post
      respond_to do |format|
        format.html do
          @comments = @post.comments.includes(:votes)
          @comment = @post.comments.build
        end

        format.json do
          render json: PostSerializer.new(@post).serialize
        end
      end
    else
      render '/shared/not_found', status: 404
    end
  end

  def new
    @post = Post.new
  end

  def create_from_api
    post = Post.new(post_create_attr)

    if post.save
      render json: { message: "heyo, it worked!"}, status: 201
    else
      render json: { errors: "oi, something broke!"}, status: 422
    end
  end

  def create
    @post = Post.new(post_create_attr)

    if @post.save
      redirect_to posts_path(page: 1)
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    post = Post.find(params[:id])
    attr = params.require(:post).permit(:title, :content, category_ids:[])

    if post.update(attr)
      # redirect_to "/posts/#{params[:id]}"
      redirect_to post_path(post)
    else
      redirect_to edit_post_path(id: post.id)
    end
  end

  private

  DEFAULT_PER_PAGE = 5
  def per_page
    return params[:per_page].to_i if params[:per_page].to_i > 0
    DEFAULT_PER_PAGE
  end

  FIRST_PAGE = 1
  def page
    return params[:page].to_i if params[:page].to_i > 0
    FIRST_PAGE
  end

  def ensure_logged_in
    if !logged_in?
      redirect_to login_path
    end
  end

  def post_create_attr
    params.require(:post).permit(:title, :content, category_ids:[])
  end
end
