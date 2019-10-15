# handle Comments
class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    # post_id = params[:post_id]
    @comment = @post.comments.build(params.require(:comment).permit(:content))
    # attrs = params.require(:comment).permit(:content).merge({post_id: params[:post_id]})
    if @comment.save
    # Comment.new(attrs).save
      # redirect_to "/posts/#{post_id}"
      #redirect_to post
      redirect_to post_path(@post)
    else
      @comments = @post.comments
      # render and not redirect, as redirect is a new instance
      render 'posts/show'
    end
  end
end
