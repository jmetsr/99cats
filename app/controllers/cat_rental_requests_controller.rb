class CatRentalRequestsController < ApplicationController
  def new
    @cat_rental_request = CatRentalRequest.new
    render :new
  end

  def create
    @cat_rental_request = current_user.cat_rental_requests.new(cat_rental_request_params)
    if @cat_rental_request.save
      redirect_to cat_url(Cat.find(params[:cat_id]))
    else
      flash.now[:errors] = @cat_rental_request.errors.full_messages
      render :new
    end
  end

  def index
    redirect_to cats_url
  end

  def approve
    @cat_rental_request = CatRentalRequest.find(params[:id])
    if @cat_rental_request.cat.owner == current_user
      @cat_rental_request.approve!
      redirect_to cat_url(@cat_rental_request.cat)
    else
      flash[:errors] = ["You cannot approve a request for someone else's cat!"]
      redirect_to cat_url(@cat_rental_request.cat)
    end
  end

  def deny
    @cat_rental_request = CatRentalRequest.find(params[:id])
    if @cat_rental_request.cat.owner == current_user
      @cat_rental_request.deny!
      redirect_to cat_url(@cat_rental_request.cat)
    else
      flash[:errors] = ["You cannot approve a request for someone else's cat!"]
      redirect_to cat_url(@cat_rental_request.cat)
    end
  end

  private
  def cat_rental_request_params
      params.require(:@cat_rental_request).permit(
      :cat_id, :start_date, :end_date, :status
      )
  end
end
