class UsersController < ApplicationController
  before_action :check_log_in

  # def index
  #   @users = User.all
  # end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login!(@user)
      redirect_to cats_url
    else
      render action: 'new'
    end
  end

  # def update
  #   respond_to do |format|
  #     if @user.update(user_params)
  #       format.html { redirect_to @user, notice: 'User was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # def destroy
  #   @user.destroy
  #   respond_to do |format|
  #     format.html { redirect_to users_url }
  #     format.json { head :no_content }
  #   end
  # end

  private

    def user_params
      params.require(:user).permit(:username, :password)
    end

    def check_log_in
      if !current_user.nil?
        redirect_to cats_url
      end
    end
end
