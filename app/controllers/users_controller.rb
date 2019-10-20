# show list of users
class UsersController < ApplicationController
  def index
    attr = params
    # @user = User.all.includes(:badges)
    @user = User.order(created_at: :desc)
                .offset(per_page * (page - 1))
                .limit(per_page)
                .includes(:badges)

    @total_pages = (User.count / per_page.to_f).ceil
  end

  def show
    @single_user = User.find(params[:id])
    @badges = @single_user.badges
  end

  def new
    @user = User.new
  end

  def create
    attr = params.require(:user).permit(:firstname, :lastname, :email, :flare, badge_ids:[])
    @user = User.new(attr)

    if @user.save
      # redirect_to '/users'
      redirect_to users_path(page: 1)
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    attr = params.require(:user).permit(:firstname, :lastname, :email, :flare, badge_ids:[])
    user.update(attr)

    # redirect_to "/users/#{params[:id]}"
    redirect_to user_path(user)
  end

  private
  def per_page
    3
  end

  def page
    params[:page].to_i || 1
  end
end
