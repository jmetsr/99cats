class CatsController < ApplicationController

  before_filter :require_ownership
  skip_before_filter :require_ownership, except: [:edit,:update]

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = current_user.cats.new(cat_params)
    if @cat.save
      redirect_to cats_url
    end
  end

  def edit
    @cat = current_user.cats.find(params[:id])
    render :edit
  end

  def update
    @cat = current_user.cats.find(params[:id])
    if @cat.update(cat_params)
      redirect_to cat_url(@cat)
    else
      render :edit
    end
  end

  private
  def cat_params
    params.require(:cat).permit(
    :name, :color, :sex, :description, :birth_date
    )
  end

  def require_ownership
    if current_user.id!= Cat.find(params[:id]).user_id
      fail
      redirect_to cats_url
    end
  end
end
