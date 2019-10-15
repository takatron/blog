# handle Categories
class CategoriesController < ApplicationController
  def index
    @category = Category.all
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
  end

  def create
    attr = params.require(:category).permit(:name)
    @category = Category.new(attr)

    if @category.save
      # redirect_to '/categorys'
      redirect_to categories_path
    else
      render :new
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    category = Category.find(params[:id])
    attr = params.require(:category).permit(:name)
    category.update(attr)

    # redirect_to "/categorys/#{params[:id]}"
    redirect_to category_path(category)
  end
end
