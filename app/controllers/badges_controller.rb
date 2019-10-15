# handle Badges
class BadgesController < ApplicationController
  def index
    @badge = Badge.all
  end

  def show
    @badge = Badge.find(params[:id])
  end

  def new
    @badge = Badge.new
  end

  def create
    attr = params.require(:badge).permit(:name)
    @badge = Badge.new(attr)

    if @badge.save
      redirect_to badges_path
    else
      render :new
    end
  end

  def edit
    @badge = Badge.find(params[:id])
  end

  def update
    badge = Badge.find(params[:id])
    attr = params.require(:badge).permit(:name)
    badge.update(attr)

    redirect_to badge_path(badge)
  end
end
