# show list of posts
class PostsController < ApplicationController
  before_action :ensure_logged_in, only:[:new, :create, :edit, :update]

  def index
    # @post = Post.all.includes(:categories)
    require 'pry'; binding.pry
    @post = Post.order(created_at: :desc)
                .offset(per_page * (page - 1))
                .limit(per_page)
                .includes(:categories, :votes)

    @total_pages = (Post.count / per_page.to_f).ceil
  end

  def show
    @post = Post.find_by(id: params[:id]) || Post.find_by(slug: params[:id])
    if @post
      @comments = @post.comments.includes(:votes)
      @comment = @post.comments.build
    else
      render '/shared/not_found', status: 404
    end
  end

  def new
    @post = Post.new
  end

  def create
    # allows only title and content
    # attr = params.require(:post).permit(:title, :content)
    # permit! allows everything
    # attr = params.require(:post).permit!
    attr = params.require(:post).permit(:title, :content, category_ids:[])
    @post = Post.new(attr)

    if @post.save
      # redirect_to '/posts'
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
    post.update(attr)

    # redirect_to "/posts/#{params[:id]}"
    redirect_to post_path(post)
  end

  private

  def per_page
    5
  end

  FIRST_PAGE = 1
  def page
    return FIRST_PAGE if params[:page].nil?
    params[:page].to_i
  end

  def ensure_logged_in
    if !logged_in?
      redirect_to login_path
    end
  end
end
